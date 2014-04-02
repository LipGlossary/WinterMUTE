# EVENTS =======================================================================

socket = io.connect()
term = $.terminal.active()

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

# # "message" is emitted when a message sent with socket.send is received. message is the sent message, and callback is an optional acknowledgement function.
# socket.on 'message', (message, callback) ->
#   console.log 'message: ' + message

# "anything" can be any event except for the reserved ones. data is data, and callback can be used to send a reply.
socket.on 'anything', (data, callback) ->
  console.log 'anything: ' + data

socket.on 'message', (message) ->
  term.echo message

socket.on 'prompt', (data) ->
  term.echo data.message
  term.push(
    (input, term) ->
      if !data.args then data.args = []
      data.args.push $.terminal.parseArguments(input)[0]
      socket.emit data.command, data.args
      term.pop()
      return
    prompt: '? > '
  )

socket.on 'create-char', ->
  term.pause()
  $('#create-char').css "visibility", "visible"
