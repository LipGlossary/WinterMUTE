User = require '../app/models/user'
Char = require '../app/models/char'

module.exports = (app) ->

  app.io.route 'create', (req) ->
    switch req.data[0]
      when 'char' then req.io.emit 'create-char'
      when 'room' then req.io.emit 'message', "I'm sorry, I cannot create rooms at this time."
      when 'object' then req.io.emit 'message', "I'm sorry, I cannot creat objects at this time."
      when undefined
        req.io.emit 'prompt',
          message : "What would you like to create?\n    char    room    object"
          command : 'create'
          args : req.data
      else req.io.emit 'message', "I cannot edit \"#{req.data[0]}\"."

  app.io.route 'edit', (req) ->
    switch req.data[0]
      when 'self' then "Sorry, I cannot edit characters at this time." # edit-char, 0
      when 'char'
        console.log "req.session.passport.user: " + JSON.stringify(req.session.passport.user)
        User.findById req.session.passport.user, (err, data) ->
          if err?
            console.log "ERROR: " + err
            req.io.emit 'error', err
          else
            if data.chars.length < 2 then req.io.emit 'message', "You don't have any characters to edit."
            else req.io.emit 'message', "Sorry, I can't edit characters at this time."
      when 'room' then req.io.emit 'message', "Sorry, I can't edit rooms at this time."
      when 'object' then req.io.emit 'message', "Sorry, I can't edit objects at this time."
      when undefined
        req.io.emit 'prompt',
          message : 'What would you like to edit?\n    self    char    room    object'
          command : 'edit'
          args : req.data
      else req.io.emit 'message', "I cannot edit \"#{req.data[0]}\"."

  app.io.route 'create-char', (req) ->
    User.findById req.session.passport.user, (userErr, user) ->
      if userErr? then req.io.emit 'error', userErr
      else
        user.chars.push
          name : req.data.name
          list : req.data.list
          look : req.data.look
          move : req.data.move
          appear : req.data.appear
        user.save (charErr, data) ->
          if charErr?
            for key of charErr.errors
              switch charErr.errors[key].path
                when 'name'
                  switch charErr.errors[key].type
                    when 'unique' then req.io.emit 'message', "There is already a character with that name."
                    when 'required' then req.io.emit 'message', "The character must have a name."
                    else req.io.emit 'error', charErr
                when 'list' then req.io.emit 'message', "The character must have a short description (\"list\" command)."
                when 'look' then req.io.emit 'message', "The character must have a long description (\"look\" command)."
                when 'move' then req.io.emit 'message', "The character must have a movement description."
                when 'appear' then req.io.emit 'message', "The character must have a [dis]appearance description."
                else req.io.emit 'error', charErr
          else req.io.emit 'message', "The character \"#{req.data.name}\" was created!"
