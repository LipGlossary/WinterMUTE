# FORMS ========================================================================

socket = io.connect()
term = $.terminal.active()

$('#tutorial button[data-cmd="ok"]').click ->
  $('#tutorial').hide()
  $('#char-form button[data-cmd="edit"]').hide()
  $('#char-form button[data-cmd="cancel"]').hide()
  $('#char-form button[data-cmd="create"]').show()
  $('#char').show()

$('button[data-cmd="cancel"]').click ->
  $('button[data-cmd="create"]').hide()
  $('button[data-cmd="edit"]').hide()
  $('#char').hide()
  $('#zone').hide()
  #$('#char-form').reset()
  #$('#zone-form').reset()
  term.resume()

$('#char-form button[data-cmd="create"]').click (event) ->
  event.preventDefault()
  $('#char').hide()
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
  $('#char').hide()
  socket.emit 'edit-char',
    name : $('#char-form input[name="name"]').val()
    list : $('#char-form input[name="list"]').val()
    look : $('#char-form textarea[name="look"]').val()
    move : $('#char-form input[name="move"]').val()
    appear : $('#char-form input[name="appear"]').val()
  #$('#char-form').reset()
  term.resume()

$('#zone-form button[data-cmd="create"]').click (event) ->
  event.preventDefault()
  $('#zone').hide()
  socket.emit 'create-zone',
    name    : $('#zone-form input[name="name"]').val()
    private : $('#zone-form input[name="private"]:checked').val()
    parent  : $('#zone-form input[name="super"]').val()
  #$('#zone-form').reset()
  term.resume()