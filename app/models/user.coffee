mongoose = require 'mongoose'
bcrypt   = require 'bcrypt-nodejs'
Char     = require './char'

User = mongoose.Schema
  email : String
  password : String
  chars : [Char]

# generating a hash
User.methods.generateHash = (password) ->
  return bcrypt.hashSync password, bcrypt.genSaltSync(8), null

# checking if password is valid
User.methods.validPassword = (password) ->
  return bcrypt.compareSync password, @password

module.exports = mongoose.model 'User', User
