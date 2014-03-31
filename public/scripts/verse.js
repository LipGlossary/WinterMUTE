// Generated by CoffeeScript 1.7.1
(function() {
  jQuery(function($) {
    var handler, options, socket, term;
    socket = io.connect();
    $.getScript('./scripts/events.js');
    $.getScript('./scripts/commands.js');
    handler = function(command, term) {
      var parse;
      parse = $.terminal.parseCommand(command);
      switch (parse.name) {
        case 'help':
          return help(term);
        case 'edit':
          socket.emit('edit', parse.args);
          return console.log('Emitted edit.');
        default:
          return term.echo("I'm sorry, I didn't understand the command \"" + parse.name + "\".");
      }
    };
    options = {
      history: true,
      prompt: '> ',
      greetings: '[[b;red;white]Welcome to WinterMUTE, a multi-user text empire.]\nFor a list of commands, type "help".\nAs the we are in development, the database cannot be trusted. Anything created here is drawn in the sand at low tide.\nVersion control is currently OFF. Edits cannot be undone.',
      processArguments: false,
      outputLimit: -1,
      linksNoReferer: false,
      exit: false,
      clear: false,
      enabled: true,
      onBlur: function(terminal) {
        return false;
      },
      historySize: false,
      height: $(window).height(),
      checkArity: false
    };
    term = $('#console').terminal(handler, options);
    $('#help').click(function() {
      return help(term);
    });
    $(window).resize(function() {
      return $('#console').css({
        "height": $(window).height() + "px"
      });
    });
    return $.terminal.active().echo('Hello from outside!');
  });

}).call(this);
