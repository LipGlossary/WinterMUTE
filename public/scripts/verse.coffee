jQuery ($) ->

# EVENTS =======================================================================

  socket = io.connect()

  # "connecting" is emitted when the socket is attempting to connect with the server.
  socket.on 'connecting', ->
    console.log 'connecting'

  # "connect" is emitted when the socket connected successfully
  socket.on 'connect', ->
    console.log 'connect'

  # "disconnect" is emitted when the socket disconnected
  socket.on 'disconnect', ->
    console.log 'disconnect'

  # "reconnecting" is emitted when the socket is attempting to reconnect with the server.
  socket.on 'reconnecting', ->
    console.log 'reconnecting'

  # "reconnect" is emitted when socket.io successfully reconnected to the server.
  socket.on 'reconnect', ->
    console.log 'reconnect'

  # "connect_failed" is emitted when socket.io fails to establish a connection to the server and has no more transports to fallback to.
  socket.on 'connect_failed', ->
    console.log 'connect_failed'

  # "reconnect_failed" is emitted when socket.io fails to re-establish a working connection after the connection was dropped.
  socket.on 'reconnect_failed', ->
    console.log 'reconnect_failed'

  # "error" is emitted when an error occurs and it cannot be handled by the other event types.
  socket.on 'error', ->
    console.log 'error'

  # "message" is emitted when a message sent with socket.send is received. message is the sent message, and callback is an optional acknowledgement function.
  socket.on 'message', (message, callback) ->
    console.log 'message: ' + message

  # "anything" can be any event except for the reserved ones. data is data, and callback can be used to send a reply.
  socket.on 'anything', (data, callback) ->
    console.log 'anything: ' + data

# TERMINAL SETUP ===============================================================

  $.getScript './scripts/commands.js'

# COMMAND HANLDER
  handler = (command, term) ->
    parse = $.terminal.parseCommand command
    switch parse.name
      when 'help' then help term
      when 'edit' then edit parse.args, term
      else term.echo "I'm sorry, I didn't understand the command \"#{parse.name}\"."

# PLUGIN OPTIONS
  options =
    history: true
    prompt: '> '
    greetings: '''
[[b;red;white]Welcome to WinterMUTE, a multi-user text empire.]
For a list of commands, type "help".
As the we are in development, the database cannot be trusted. Anything created here is drawn in the sand at low tide.
Version control is currently OFF. Edits cannot be undone.
'''
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

# MISCELLANEOUS ================================================================
  $(window).resize -> $('#console').css "height": $(window).height() + "px"
  $.terminal.active().echo 'Hello from outside!'