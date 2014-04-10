# FORMS ========================================================================

socket = io.connect()
term = $.terminal.active()

$('#char-form button[data-cmd="cancel"]').click ->
  $('#char-form button[data-cmd="create"]').css "visibility", "hidden"
  $('#char-form button[data-cmd="edit"]').css "visibility", "hidden"
  $('#char').css "visibility", "hidden"
  #$('#char-form').reset()
  term.resume()

$('#char-form button[data-cmd="create"]').click (event) ->
  event.preventDefault()
  $('#char').css "visibility", "hidden"
  socket.emit 'create-char',
    name : $('#char-form input[name="name"]').val()
    list : $('#char-form input[name="list"]').val()
    look : $('#char-form textarea[name="look"]').val()
    move : $('#char-form input[name="move"]').val()
    appear : $('#char-form input[name="appear"]').val()
  #$('#char-form').reset()
  term.resume()

$('#char-form button[data-cmd="edit"]').click (event) ->
  event.preventDefault()
  $('#char').css "visibility", "hidden"
  socket.emit 'edit-char',
    name : $('#char-form input[name="name"]').val()
    list : $('#char-form input[name="list"]').val()
    look : $('#char-form textarea[name="look"]').val()
    move : $('#char-form input[name="move"]').val()
    appear : $('#char-form input[name="appear"]').val()
  #$('#char-form').reset()
  term.resume()