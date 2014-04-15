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



socket.on 'error', ->
  console.log 'error'

socket.emit 'ready'

socket.on 'update', (user) ->
  $('#info').empty()
  $('#info').append '<p>Hello, </p>'
  if user.currentChar == 0
    $('#info p').append '<b>' + user.chars[0].name + '</b>.'
  else $('#info p').append user.chars[0].name + '.'
  if user.chars.length > 1
    $('#info').append '<p>Characters:</p>', '<ul></ul>'
    for char, index in user.chars when index isnt 0
      if index == user.currentChar
        $('#info ul').append '<li><b>' + char.name + '</b></li>'
      else $('#info ul').append '<li>' + char.name + '</li>'
  if user.visible
    $('#info').append '<p>You are currently visible.</p>'
  else $('#info').append '<p>You are currently invisible.</p>'


socket.on 'tutorial', ->
  term.pause()
  $('#tutorial').show()

socket.on 'message', (message) ->
  term.echo message

socket.on 'prompt', (data) ->
  term.echo data.message
  term.echo "    TIP: Enter \"q\" to cancel."
  term.push(
    (input, term) ->
      unless data.args? then data.args = []
      input = $.terminal.parseArguments(input)[0]
      if input isnt 'q'
        data.args.push input
        socket.emit data.command, data.args
      term.pop()
      return
    prompt: '? > '
  )

socket.on 'create-char', ->
  term.pause()
  $('#char-form button[data-cmd="edit"]').hide()
  $('#char-form button[data-cmd="create"]').show()
  $('#char').show()

socket.on 'edit-char', (data) ->
  term.pause()
  $('#char-form input[name="name"]').val(data.name)
  $('#char-form input[name="list"]').val(data.list)
  $('#char-form textarea[name="look"]').val(data.look)
  $('#char-form input[name="move"]').val(data.move)
  $('#char-form input[name="appear"]').val(data.appear)
  $('#char-form button[data-cmd="create"]').hide()
  $('#char-form button[data-cmd="edit"]').show()
  $('#char').show()

socket.on 'ooc', (data) ->
  term.echo "[[;yellow;black](OOC) " + data.user + ": " + data.message + "]"
