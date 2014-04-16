mongoose = require 'mongoose'
User = require '../app/models/user'
Char = require '../app/models/char'
Zone = require '../app/models/zone'

module.exports = (app) ->

  generateCode = (req, obj) ->
    code = ('000000' + ( Math.random() * 0xFFFFFF << 0 ).toString( 16 )).slice( -6 )
    Zone
    .findOne code : code
    .exec (err, data) ->
      if err? then req.io.emit 'error', err
      else if data? then generateCode req, obj
      else
        obj.code = code
        obj.save (saveErr, saveData) ->
          if saveErr? then req.io.emit 'error', saveErr

  app.io.route 'ready', (req) ->
    User
    .findById req.session.passport.user
    .populate 'chars'
    .exec (err, user) ->
      if not user.chars[0]?
        req.io.emit 'tutorial'
      else req.io.emit 'update', user

  commands =
    'create' :
      'char'   : (req) -> req.io.emit 'create-char'
      'room'   : (req) -> req.io.emit 'message', "I'm sorry, I cannot create rooms at this time."
      'object' : (req) -> req.io.emit 'message', "I'm sorry, I cannot creat objects at this time."
      'zone'   : (req) -> req.io.emit 'create-zone'
    
    'edit' :

      'self' : (req) ->
        User
        .findById req.session.passport.user
        .exec (err, user) ->
          if err? then req.io.emit 'error', err
          else
            Char
            .findById user.chars[0]
            .exec (err, char) ->
              if err? then req.io.emit 'error', err
              else
                req.session.editId = user.chars[0]._id ? user.chars[0]
                req.io.emit 'edit-char', char

      'char' : (req) ->
        unless req.data[1]?
          User
          .findById req.session.passport.user
          .populate 'chars'
          .exec (err, user) ->
            if user.chars.length < 2
              req.io.emit 'message', "You don't have any characters to edit."
            else
              charList = ""
              for char, index in user.chars when index > 0
                charList += '    ' + char.name
              req.io.emit 'prompt',
                message : "Which character would you like to edit?\n" + charList
                command : 'edit'
                args    : req.data
        else
          Char
          .findOne name : req.data[1]
          .exec (err, char) ->
            unless char?
              req.io.emit 'message', "Sorry, you can't edit character \"#{req.data[1]}\".\n    TIP: Did you spell it correctly?\n    TIP: If your character's name has a space in it, you must enclose it in quotes."
            else unless char.owner.toString() is req.session.passport.user
              req.io.emit 'message', "Sorry, you don't have permission to edit \"#{req.data[1]}\"."
            else
              req.session.editId = char._id
              req.io.emit 'edit-char', char

      'room' : (req) -> req.io.emit 'message', "Sorry, I can't edit rooms at this time."
      
      'object' : (req) -> req.io.emit 'message', "Sorry, I can't edit objects at this time."

  app.io.route 'command', (req) ->
    req.io.emit 'message', '''

[[;white;black]COMMAND     ARGUMENTS         DESCRIPTION]

commands                      List of commands
help                          Launch tutorial page

create                        Create anything
            char              Create a new character
            room              Create a new room
            object            Create a new object

edit                          Edit anything
            self              Edit your out-of-character self
            char              Edit a characters
            char, <name>      Edit the character <name>
            room              Edit a room

'''

  app.io.route 'create', (req) ->
    unless commands['create'][req.data[0]]?(req)
      if not req.data[0]?
        req.io.emit 'prompt',
        message : "What would you like to create?\n    char    room    object    zone"
        command : 'create'
        args : req.data
      else req.io.emit 'message', "I cannot edit \"#{req.data[0]}\"."

  app.io.route 'edit', (req) ->
    unless commands['edit'][req.data[0]]?(req)
      if req.data[0]?
        req.io.emit 'prompt',
          message : 'What would you like to edit?\n    self    char    room    object'
          command : 'edit'
          args : req.data
      else req.io.emit 'message', "I cannot edit \"#{req.data[0]}\"."

  charErrors =
    'name'   : (err, req) -> req.io.emit 'message', "The character must have a name."
    'list'   : (err, req) -> req.io.emit 'message', "The character must have a short description (\"list\" command)."
    'look'   : (err, req) -> req.io.emit 'message', "The character must have a long description (\"look\" command)."
    'move'   : (err, req) -> req.io.emit 'message', "The character must have a movement description."
    'appear' : (err, req) -> req.io.emit 'message', "The character must have a [dis]appearance description."

  app.io.route 'create-char', (req) ->
    newChar = 
      owner :  req.session.passport.user
      name : req.data.name
      list : req.data.list
      look : req.data.look
      move : req.data.move
      appear : req.data.appear
    Char.create newChar, (charErr, charData) ->
      if charErr?
        if charErr.code == 11000
          req.io.emit 'message', "A character with that name already exists."
        for key of charErr.errors when not charErrors[key]?(charErr, req)
          req.io.emit 'error', charErr
      else
        User
        .findByIdAndUpdate req.session.passport.user,
          $push :
            chars : charData._id
        .populate 'chars'
        .exec (userErr, userData) ->
          if userErr? then req.io.emit 'error', userErr
          else
            req.io.emit 'message', "The character \"#{req.data.name}\" was created!"
            req.io.emit 'update', userData

  app.io.route 'edit-char', (req) ->
    Char
    .findByIdAndUpdate req.session.editId,
      $set :
        name : req.data.name
        list : req.data.list
        look : req.data.look
        move : req.data.move
        appear : req.data.appear
    .exec (err, data) ->
      if err?
        if err.code == 11000
          req.io.emit 'message', "A character with that name already exists."
        for key of err.errors when not charErrors[key]?(err, req)
          req.io.emit 'error', err
      else
        req.io.emit 'message', "The character \"#{req.data.name}\" was saved!"
        User
        .findById req.session.passport.user
        .populate 'chars'
        .exec (popErr, popData) ->
          if popErr? then req.io.emit 'error', popErr
          else req.io.emit 'update', popData

  app.io.route 'create-zone', (req) ->
    newZone = new Zone
    newZone.owner = req.session.passport.user
    newZone.name = req.data.name
    console.log req.data.private
    if req.data.private == 'private'
      newZone.private = true
    else newZone.private = false
    Zone
    .findOne code : req.data.parent
    .exec (err, parent) ->
      if err? then req.io.emit 'error', err
      else if not parent?
        if req.data.parent != ''
          req.io.emit 'message', "That super-zone does not exist."
          return
      else newZone.parent = parent._id
      newZone.save (saveErr, saveZone) ->
        if saveErr?
          if saveErr.errors?
            req.io.emit 'message', "The zone must have a name."
          else if saveErr.code?
            req.io.emit 'message', "A zone with that name already exists."
          else req.io.emit 'error', saveErr
        else
          generateCode req, saveZone
          parent?.update(
            $push :
              zones : saveZone._id
            (parentErr, parentData) ->
              if parentErr? then req.io.emit 'error', parentErr
          )
          req.io.emit 'message', "The zone #{req.data.name} was created!"

  app.io.route 'ooc', (req) ->
    User
    .findById req.session.passport.user
    .populate 'chars'
    .exec (err, user) ->
      if err? req.io.emit
      else
        app.io.broadcast 'ooc',
          user    : user.chars[0].name
          message : req.data
