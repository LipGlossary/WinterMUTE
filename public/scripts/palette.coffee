# COMMAND PALETTE ==============================================================

socket = io.connect()
term = $.terminal.active()

toggles =
  '#create-btn' :
    hide : [ '#create-btn' ]
    show : [
      '#create-char-btn'
      '#create-btn-cancel'
    ]
  '#create-char-btn' :
    hide : [
      '#create-char-btn'
      '#create-btn-cancel'
      '#char-form button[data-cmd="edit"]'
    ]
    show : [
      '#create-btn'
      '#char-form button[data-cmd="create"]'
      '#char'
    ]
  '#create-btn-cancel' :
    hide : [
      '#create-char-btn'
      '#create-btn-cancel'
    ]
    show : [ '#create-btn' ]
  '#edit-btn' :
    hide : [ '#edit-btn' ]
    show : [
      '#edit-char-btn'
      '#edit-btn-cancel'
    ]
  '#edit-char-btn' :
    hide : [
      '#edit-char-btn'
      '#edit-btn-cancel'
    ]
    show : [ '#edit-btn' ]
  '#edit-btn-cancel' :
    hide : [
      '#edit-char-btn'
      '#edit-btn-cancel'
    ]
    show : [ '#edit-btn']

toggle = (button) ->
  $(thing).hide() for thing in toggles[button].hide
  $(thing).show() for thing in toggles[button].show

$('#help').click -> socket.emit 'help'
$('#create-btn').click -> toggle '#create-btn'
$('#create-char-btn').click ->
  term.pause()
  toggle '#create-char-btn'
$('#create-btn-cancel').click -> toggle '#create-btn-cancel'
$('#edit-btn').click -> toggle '#edit-btn'
$('#edit-char-btn').click ->
  toggle '#edit-char-btn'
  socket.emit 'edit', ['char']
$('#edit-btn-cancel').click -> toggle '#edit-btn-cancel'