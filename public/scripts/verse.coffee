jQuery ($) ->

  socket = io.connect()

# TERMINAL SETUP ===============================================================

  $.getScript './scripts/commands.js'

# COMMAND HANLDER
  handler = (command, term) ->
    parse = $.terminal.parseCommand command
    switch parse.name
      when 'help' then help term
      when 'edit'
        socket.emit 'edit', parse.args
        return
      else term.echo "I'm sorry, I didn't understand the command \"#{parse.name}\"."

# PLUGIN OPTIONS
  greeting = '''
[[b;red;white]Welcome to WinterMUTE, a multi-user text empire.]
For a list of commands, type "help".
As the we are in development, the database cannot be trusted. Anything created here is drawn in the sand at low tide.
Version control is currently OFF. Edits cannot be undone.

'''
  options =
    history: true
    prompt: '> '
    greetings: greeting
    processArguments: false
    outputLimit: -1
    linksNoReferer: false
    exit: false
    clear: false
    enabled: true
    onBlur: (terminal) -> return false
    historySize: false
    height: $(window).height()
    checkArity: false

# INSTANTIATION
  term = $('#console').terminal handler, options

# COMMAND PALETTE ==============================================================

  $('#help').click -> help term

# EVENTS =======================================================================
  $.getScript './scripts/events.js'

# MISCELLANEOUS ================================================================
  $(window).resize -> $('#console').css "height": $(window).height() + "px"
  $.terminal.active().echo 'Hello from outside!'