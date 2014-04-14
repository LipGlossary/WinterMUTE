mongoose = require 'mongoose'
User = require '../app/models/user'
Char = require '../app/models/char'

module.exports = (app) ->

  commands =
    'create' :
      'char'   : (req) -> req.io.emit 'create-char'
      'room'   : (req) -> req.io.emit 'message', "I'm sorry, I cannot create rooms at this time."
      'object' : (req) -> req.io.emit 'message', "I'm sorry, I cannot creat objects at this time."
    
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

  app.io.route 'help', (req) ->
    req.io.emit 'message', '''

[[;white;black]COMMAND     ARGUMENTS         DESCRIPTION]

help        N/A               List of commands

create                        Create anything
            char              Create a new character
            room              Create a new room
            object            Create a new object

edit                          Edit anything
            self              Edit your out-of-character self
            char              Edit a characters
            char, <name>      Edit the character <name>
            room              Edit a room

[[;blue;black]Coming soon...]

[[;white;black]COMMAND     ARGUMENTS         DESCRIPTION]

edit        room, <code>      Edit room <code>
            object            Edit an object
            object, <code>    Edit object <code>

'''

  app.io.route 'create', (req) ->
    unless commands['create'][req.data[0]]?(req)
      if not req.data[0]?
        req.io.emit 'prompt',
        message : "What would you like to create?\n    char    room    object"
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
        .exec (userErr, userData) ->
          if userErr? then req.io.emit 'error', userErr
          else req.io.emit 'message', "The character \"#{req.data.name}\" was created!"

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
      else req.io.emit 'message', "The character \"#{req.data.name}\" was saved!"

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
