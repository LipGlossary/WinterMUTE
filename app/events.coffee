User = require '../app/models/user'

module.exports = (app) ->

  app.io.route 'edit', (req) ->
    switch req.data[0]
      when 'self' then editChar req, 0
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
      when undefined
        req.io.emit 'prompt',
          message : 'What would you like to edit?\n    self    char    room'
          command : 'edit'
          args : req.data
      else req.io.emit 'message', "I cannot edit \"#{req.data[0]}\"."

  editChar = (req, index) ->
    req.io.emit 'message', "Sorry, I cannot edit characters at this time."
