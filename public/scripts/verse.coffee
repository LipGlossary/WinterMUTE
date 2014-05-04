jQuery ($) ->

  socket = io.connect()

# TERMINAL SETUP ===============================================================

# COMMAND HANLDER

  commands =
    'help'      :        -> window.open('/tutorial')
    'proto'     :        -> window.open('/proto')
    'command'   :        -> socket.emit 'command'
    'status'    :        -> socket.emit 'status'
    'who'       :        -> socket.emit 'who'
    'vis'       :        -> socket.emit 'vis'
    'visible'   :        -> socket.emit 'vis'
    'invis'     :        -> socket.emit 'invis'
    'invisible' :        -> socket.emit 'invis'
    'char'      : (args) -> socket.emit 'char', args
    'create'    : (args) -> socket.emit 'create', args
    'edit'      : (args) -> socket.emit 'edit', args

  channels =
    'ooc'   : (msg) -> socket.emit 'ooc', msg
    'say'   : (msg) -> socket.emit 'say', msg
    'pose'  : (msg) -> socket.emit 'pose', msg
    'spoof' : (msg) -> socket.emit 'spoof', msg

  handler = (command, term) ->
    parse = $.terminal.parseCommand command
    unless commands[parse.name]?(parse.args)
      unless channels[parse.name]?(parse.rest)
        term.echo "I'm sorry, I didn't understand the command \"#{parse.name}\"."
    return

# PLUGIN OPTIONS
  greeting = '''
[[b;red;black]Welcome to WinterMUTE, a multi-user text empire.]
[[;white;black]For the detailed help pages, type "help".
For a list of commands, type "command".
As we are in development, the database cannot be trusted. Anything created here is drawn in the sand at low tide.
Version control is currently OFF. Edits cannot be undone.]

[[b;green;black]WELCOME, PROTOTYPERS!]
[[;green;black]Thank you very much for participating in this exposition. Here are some things you should know:]
[[;white;black]1. The "help" command gives you lots of information for things that are not implemented yet. For the prototype help page, please use the command "proto".
2. Please keep profanity to a minimum. I'm trying to get hired by the people who might be looking at you play!
3. Please make use of all the commands available to you--don't just chat on the OOC channel all night.
4. If text is falling out of the terminal, just resize the window.
5. Have fun!]

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
    height: $('body').height()
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
  $('#console').css "height": $('body').height() + "px"
  $(window).resize ->
    $('#console').css "height": $('body').height() + "px"