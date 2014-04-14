jQuery ($) ->

  socket = io.connect()

# TERMINAL SETUP ===============================================================

# COMMAND HANLDER

  commands =
    'help'   :        -> socket.emit 'help'
    'edit'   : (args) -> socket.emit 'edit', args
    'create' : (args) -> socket.emit 'create', args

  channels =
    'ooc' : (msg) -> socket.emit 'ooc', msg

  handler = (command, term) ->
    parse = $.terminal.parseCommand command
    unless commands[parse.name]?(parse.args)
      unless channels[parse.name]?(parse.rest)
        term.echo "I'm sorry, I didn't understand the command \"#{parse.name}\"."
    return

# PLUGIN OPTIONS
  greeting = '''
[[b;red;black]Welcome to WinterMUTE, a multi-user text empire.]
For a list of commands, type "help".
As we are in development, the database cannot be trusted. Anything created here is drawn in the sand at low tide.
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
    height: $('body').height() * 0.9
    checkArity: false

# INSTANTIATION
  term = $('#console').terminal handler, options

# ENVIRONMENT ==================================================================

  # COMMAND PALETTE
  $.getScript './scripts/palette.js'

  # EVENTS
  $.getScript './scripts/events.js'

  # FORMS
  $.getScript './scripts/forms.js'

# MISCELLANEOUS ================================================================
  $(window).resize ->
    $('#console').css "height": $('body').height() * 0.9 + "px"