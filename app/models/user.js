// Generated by CoffeeScript 1.7.1
(function() {
  var User, bcrypt, mongoose;

  mongoose = require('mongoose');

  bcrypt = require('bcrypt-nodejs');

  User = mongoose.Schema({
    email: {
      type: String,
      required: true,
      unique: true
    },
    password: {
      type: String,
      required: true
    },
    chars: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Char'
      }
    ],
    currentChar: {
      type: Number,
      required: true
    },
    visible: {
      type: Boolean,
      required: true
    },
    room: {
      type: String,
      required: true
    }
  });

  User.methods.generateHash = function(password) {
    return bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
  };

  User.methods.validPassword = function(password) {
    return bcrypt.compareSync(password, this.password);
  };

  module.exports = mongoose.model('User', User);

}).call(this);
