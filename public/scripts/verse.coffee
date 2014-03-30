jQuery ($) ->

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

  help = ->
    this.echo '''

COMMAND     ARGUMENTS    DESCRIPTION

help                     List of commands

echo                     Echoes any arguments


[[;blue;white]Coming soon...]

COMMAND     ARGUMENTS    DESCRIPTION

tutorial    reset        Resets the tutorial
            skip         No more tutorials will be seen

'''

  commands =
    help: help
    echo: (arg) -> this.echo arg

  options =
    history: true
    prompt: '> '
    greetings: '[[b;red;white]Welcome to Winter MUTE, a multi-user text empire.]\nFor a list of commands, type "help".'
    processArguments: false
    outputLimit: -1
    linksNoReferer: false
    exit: false
    clear: false
    enabled: true
    onBlur: (terminal) -> return false
    historySize: false
    height: $(window).height()

  $('#console').terminal commands, options

  $.terminal.active().echo 'Hello from outside!'