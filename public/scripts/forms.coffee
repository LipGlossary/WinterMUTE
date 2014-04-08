# FORMS ========================================================================

socket = io.connect()
term = $.terminal.active()

$('#create-char button[type="button"]').click ->
  $('#create-char').css "visibility", "hidden"
  #$('#create-char-form').reset()
  term.resume()

$('#create-char-form').on 'submit', (event) ->
  event.preventDefault()
  $('#create-char').css "visibility", "hidden"
  socket.emit 'create-char',
    name : $('#create-char-form input[name="name"]').val()
    list : $('#create-char-form input[name="list"]').val()
    look : $('#create-char-form textarea[name="look"]').val()
    move : $('#create-char-form input[name="move"]').val()
    appear : $('#create-char-form input[name="appear"]').val()
  #$('#create-char-form').reset()
  term.resume()

$('#edit-char button[type="button"]').click ->
  $('#edit-char').css "visibility", "hidden"
  #$('#edit-char-form').reset()
  term.resume()

$('#edit-char-form').on 'submit', (event) ->
  event.preventDefault()
  $('#edit-char').css "visibility", "hidden"
  socket.emit 'edit-char',
    name : $('#edit-char-form input[name="name"]').val()
    list : $('#edit-char-form input[name="list"]').val()
    look : $('#edit-char-form textarea[name="look"]').val()
    move : $('#edit-char-form input[name="move"]').val()
    appear : $('#edit-char-form input[name="appear"]').val()
  #$('#edit-char-form').reset()
  term.resume()