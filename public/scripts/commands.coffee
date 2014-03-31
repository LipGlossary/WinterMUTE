@help = (term) -> term.echo '''

COMMAND     ARGUMENTS    DESCRIPTION

help                     List of commands

echo                     Echoes any arguments

edit        self         Edit your out-of-character self


[[;blue;white]Coming soon...]

COMMAND     ARGUMENTS    DESCRIPTION

tutorial    reset        Resets the tutorial
            skip         No more tutorials will be seen

'''

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

editChar = (char, term) -> term.echo "Editing \"#{char}\"!"

editRoom = (room, term) -> term.echo "Editing room \"#{room}\"!"