@help = (term) -> term.echo '''

COMMAND     ARGUMENTS       DESCRIPTION

help        N/A             List of commands

edit                        Edit anything
            self            Edit your out-of-character self

[[;blue;white]Coming soon...]

COMMAND     ARGUMENTS       DESCRIPTION

edit        char            Edit a characters
            char, <name>    Edit the character <name>
            room            Edit a room
            room, <code>    Edit room <code>

tutorial    reset           Resets the tutorial
            skip            No more tutorials will be seen

'''
###
@edit = (args, term) ->
  switch args[0]
    when 'self' then editChar 'self', term
    when 'char' then editChar args[1], term
    when 'room' then editRoom args[1], term
    when undefined
      term.echo 'What would you like to edit?\n    self    char    room'
      term.push(
        (command, term) ->
          console.log 'Command: ' + command
          what = $.terminal.parseCommand(command).name
          console.log 'What: ' + what
          switch what
            when 'self' then editChar 'self', term
            when 'char' then editChar null, term
            when 'room' then editRoom null, term
            else term.echo "I cannot edit \"#{what}\"."
          term.pop()
        prompt: '? > '
      )
    else "I cannot edit \"#{args[0]}\"."

editChar = (char, term) -> 
  switch char
    when 'self' then socket.emit 'edit self'
    when undefined
      term.echo 'What character would you like to edit?\n    self'
    else term.echo "Sorry, I cannot edit characters other than yourself at this time."

editRoom = (room, term) -> term.echo "Sorry, I cannot edit rooms at this time."
###