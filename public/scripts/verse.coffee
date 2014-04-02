jQuery ($) ->

  socket = io.connect()

# TERMINAL SETUP ===============================================================

  $.getScript './scripts/commands.js'

# COMMAND HANLDER
  handler = (command, term) ->
    parse = $.terminal.parseCommand command
    switch parse.name
      when 'help' then help term
      when 'edit' then socket.emit 'edit', parse.args
      when 'create' then socket.emit 'create', parse.args
      else term.echo "I'm sorry, I didn't understand the command \"#{parse.name}\"."
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
    $('#create-char').css "visibility", "visible"
  $('#create-btn-cancel').click ->
    $('#create-char-btn').css "visibility", "hidden"
    $('#create-btn-cancel').css "visibility", "hidden"
    $('#create-btn').css "visibility", "visible"

# EVENTS =======================================================================

  $.getScript './scripts/events.js'

# FORMS ========================================================================

  $('#create-char button').click ->
    $('#create-char').css "visibility", "hidden"
    term.resume()

  $('#create-char-form').on 'submit', (event) ->
    event.preventDefault()
    socket.emit 'create-char',
      name : $('#create-char-form input[name="name"]').val()
      list : $('#create-char-form input[name="list"]').val()
      look : $('#create-char-form textarea[name="look"]').val()
      move : $('#create-char-form input[name="move"]').val()
      appear : $('#create-char-form input[name="appear"]').val()
    $('#create-char-form').reset()

# MISCELLANEOUS ================================================================
  $(window).resize -> $('#console').css "height": $(window).height() + "px"
  $.terminal.active().echo 'Hello from outside!'