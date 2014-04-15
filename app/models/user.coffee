mongoose = require 'mongoose'
bcrypt   = require 'bcrypt-nodejs'

User = mongoose.Schema
  email :
  	type     : String
  	required : true
  	unique   : true
  password :
  	type     : String
  	required : true
  chars : [
  	type : mongoose.Schema.Types.ObjectId
  	ref  : 'Char'
  ]
  currentChar :
  	type     : Number
  	required : true
  visible :
  	type     : Boolean
  	required : true

# generating a hash
User.methods.generateHash = (password) ->
  return bcrypt.hashSync password, bcrypt.genSaltSync(8), null

# checking if password is valid
User.methods.validPassword = (password) ->
  return bcrypt.compareSync password, @password

module.exports = mongoose.model 'User', User
