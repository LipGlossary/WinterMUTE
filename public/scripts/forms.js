// Generated by CoffeeScript 1.7.1
(function() {
  var getChar, getZone, socket, term;

  socket = io.connect();

  term = $.terminal.active();

  $('#tutorial button[data-cmd="ok"]').click(function() {
    $('#tutorial').hide();
    $('#char-form button[data-cmd="edit"]').hide();
    $('#char-form button[data-cmd="cancel"]').hide();
    $('#char-form button[data-cmd="create"]').show();
    return $('#char').show();
  });

  $('button[data-cmd="cancel"]').click(function() {
    $('button[data-cmd="create"]').hide();
    $('button[data-cmd="edit"]').hide();
    $('#char').hide();
    $('#zone').hide();
    return term.resume();
  });

  getChar = function() {
    var char;
    char = {
      name: $('#char-form input[name="name"]').val(),
      list: $('#char-form input[name="list"]').val(),
      look: $('#char-form textarea[name="look"]').val(),
      move: $('#char-form input[name="move"]').val(),
      appear: $('#char-form input[name="appear"]').val()
    };
    return char;
  };

  $('#char-form button[data-cmd="create"]').click(function(event) {
    event.preventDefault();
    $('#char').hide();
    socket.emit('create-char', getChar());
    return term.resume();
  });

  $('#char-form button[data-cmd="edit"]').click(function(event) {
    event.preventDefault();
    $('#char').hide();
    socket.emit('edit-char', getChar());
    return term.resume();
  });

  getZone = function() {
    var zone;
    zone = {
      name: $('#zone-form input[name="name"]').val(),
      "private": $('#zone-form input[name="private"]:checked').val() === 'private',
      parent: $('#zone-form input[name="super"]').val()
    };
    return zone;
  };

  $('#zone-form button[data-cmd="create"]').click(function(event) {
    event.preventDefault();
    $('#zone').hide();
    socket.emit('create-zone', getZone());
    return term.resume();
  });

  $('#zone-form button[data-cmd="edit"]').click(function(event) {
    event.preventDefault();
    $('#zone').hide();
    socket.emit('edit-zone', getZone());
    return term.resume();
  });

}).call(this);
