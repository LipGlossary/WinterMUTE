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



socket.on 'error', (data) ->
  msg = "[[;red;black]ERROR: "
  for key, value of data
    msg += key + ' : ' + value + '\n'
  term.echo msg + ']'

socket.emit 'ready'

socket.on 'reconnect', -> socket.emit 'reconnect'

socket.on 'redirect', (data) ->
  location.href = data

socket.on 'tutorial', ->
  term.pause()
  $('#tutorial').show()

socket.on 'update', (user) ->
  $.user = user

socket.on 'who', (users) ->
  $('#who').empty()
  $('#who').append '<p>Online now:</p><ul></ul>'
  for user in users
    $('#who ul').append '<li>' + user + '</li>'

socket.on 'message', (message) ->
  term.echo message

socket.on 'prompt', (data) ->
  term.echo data.message
  term.echo "    [[;gray;black]TIP: Enter \"q\" to cancel.]"
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

socket.on 'create-zone', (data) ->
  term.pause()
  $('#zone-form button[data-cmd="edit"]').hide()
  $('#zone-form button[data-cmd="create').show()
  $('#zone').show()

socket.on 'edit-zone', (data) ->
  term.pause()
  $('#zone-form input[name="name"]').val(data.name)
  if data.private == true
    $('#zone-form input[value="private"]').attr('checked', 'checked')
  else $('#zone-form input[value="public"]').attr('checked', 'checked')
  $('#zone-form input[name="super"]').val(data.parent?.code ? '')
  $('#zone-form button[data-cmd="create"]').hide()
  $('#zone-form button[data-cmd="edit"]').show()
  $('#zone-form div.list').empty()
  if data.zones.length > 0
    $('#zone-form div.list').append '<p>Sub-zones:</p><ul class="zones"></ul>'
    for zone in data.zones
      $('#zone-form div.list ul.zones').append '<li>' + zone.name + ' (' + zone.code + ')</li>'
  if data.rooms.length > 0
    $('#zone-form div.list').append '<p>Rooms:</p><ul class="rooms"></ul>'
    for room in data.rooms
      $('#zone-form div.list ul.rooms').append '<li>' + room.name + ' (' + room.code + ')</li>'
  $('#zone').show()

socket.on 'ooc', (data) ->
  term.echo "[[;yellow;black](OOC) " + data.user + ": " + data.message + "]"
