// Generated by CoffeeScript 1.7.1
(function() {
  jQuery(function($) {
    var channels, commands, greeting, handler, options, socket, term;
    socket = io.connect();
    commands = {
      'help': function() {
        return window.open('/tutorial');
      },
      'proto': function() {
        return window.open('/proto');
      },
      'command': function() {
        return socket.emit('command');
      },
      'status': function() {
        return socket.emit('status');
      },
      'who': function() {
        return socket.emit('who');
      },
      'vis': function() {
        return socket.emit('vis');
      },
      'visible': function() {
        return socket.emit('vis');
      },
      'invis': function() {
        return socket.emit('invis');
      },
      'invisible': function() {
        return socket.emit('invis');
      },
      'char': function(args) {
        return socket.emit('char', args);
      },
      'create': function(args) {
        return socket.emit('create', args);
      },
      'edit': function(args) {
        return socket.emit('edit', args);
      }
    };
    channels = {
      'ooc': function(msg) {
        return socket.emit('ooc', msg);
      },
      'say': function(msg) {
        return socket.emit('say', msg);
      },
      'pose': function(msg) {
        return socket.emit('pose', msg);
      }
    };
    handler = function(command, term) {
      var parse, _name, _name1;
      parse = $.terminal.parseCommand(command);
      if (!(typeof commands[_name = parse.name] === "function" ? commands[_name](parse.args) : void 0)) {
        if (!(typeof channels[_name1 = parse.name] === "function" ? channels[_name1](parse.rest) : void 0)) {
          term.echo("I'm sorry, I didn't understand the command \"" + parse.name + "\".");
        }
      }
    };
    greeting = '[[b;red;black]Welcome to WinterMUTE, a multi-user text empire.]\n[[;white;black]For the detailed help pages, type "help".\nFor a list of commands, type "command".\nAs we are in development, the database cannot be trusted. Anything created here is drawn in the sand at low tide.\nVersion control is currently OFF. Edits cannot be undone.]\n\n[[b;green;black]WELCOME, PROTOTYPERS!]\n[[;green;black]Thank you very much for participating in this exposition. Here are some things you should know:]\n[[;white;black]1. The "help" command gives you lots of information for things that are not implemented yet. For the prototype help page, please use the command "proto".\n2. Please keep profanity to a minimum. I\'m trying to get hired by the people who might be looking at you play!\n3. Please make use of all the commands available to you--don\'t just chat on the OOC channel all night.\n4. If text is falling out of the terminal, just resize the window.\n5. Have fun!]\n';
    options = {
      history: true,
      prompt: '> ',
      greetings: greeting,
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
      height: $('body').height(),
      checkArity: false
    };
    term = $('#console').terminal(handler, options);
    $.getScript('./scripts/palette.js');
    $.getScript('./scripts/events.js');
    $.getScript('./scripts/forms.js');
    $('#console').css({
      "height": $('body').height() + "px"
    });
    return $(window).resize(function() {
      return $('#console').css({
        "height": $('body').height() + "px"
      });
    });
  });

}).call(this);
