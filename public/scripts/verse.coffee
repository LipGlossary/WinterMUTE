jQuery ($) ->

  socket = io.connect()

# TERMINAL SETUP ===============================================================

  $.getScript './scripts/commands.js'

# COMMAND HANLDER

  commands =
    'help'   :        -> help term
    'edit'   : (args) -> socket.emit 'edit', args
    'create' : (args) -> socket.emit 'create', args

  handler = (command, term) ->
    parse = $.terminal.parseCommand command
    unless commands[parse.name]?(parse.args)
      term.echo "I'm sorry, I didn't understand the command \"#{parse.name}\"."
    return

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
  $('#create-btn').click ->
    $('#create-btn').css "visibility", "hidden"
    $('#create-char-btn').css "visibility", "visible"
    $('#create-btn-cancel').css "visibility", "visible"
  $('#create-char-btn').click ->
    $('#create-char-btn').css "visibility", "hidden"
    $('#create-btn-cancel').css "visibility", "hidden"
    $('#create-btn').css "visibility", "visible"
    term.pause()
    $('#char-form button[data-cmd="edit"]').css "visibility", "hidden"
    $('#char-form button[data-cmd="create"]').css "visibility", "visible"
    $('#char').css "visibility", "visible"
  $('#create-btn-cancel').click ->
    $('#create-char-btn').css "visibility", "hidden"
    $('#create-btn-cancel').css "visibility", "hidden"
    $('#create-btn').css "visibility", "visible"

# EVENTS =======================================================================

  $.getScript './scripts/events.js'

# FORMS ========================================================================

  $.getScript './scripts/forms.js'

# MISCELLANEOUS ================================================================
  $(window).resize -> $('#console').css "height": $(window).height() + "px"
  $.terminal.active().echo 'Hello from outside!'