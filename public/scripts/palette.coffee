# COMMAND PALETTE ==============================================================

socket = io.connect()

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

toggle = (button) ->
  $(thing).hide() for thing in toggles[button].hide
  $(thing).show() for thing in toggles[button].show

$('#help').click -> socket.emit 'help'
$('#create-btn').click -> toggle '#create-btn'
$('#create-char-btn').click ->
  term.pause()
  toggle '#create-char-btn'
$('#create-btn-cancel').click -> toggle '#create-btn-cancel'