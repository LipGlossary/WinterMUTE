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
  room :
    type     : String
    required : true
    default  : '000001'

# generating a hash
User.methods.generateHash = (password) ->
  return bcrypt.hashSync password, bcrypt.genSaltSync(8), null

# checking if password is valid
User.methods.validPassword = (password) ->
  return bcrypt.compareSync password, @password

User.methods.addChar = (id, done) ->
  @chars.push id
  @save (err, data) -> done err, data

User.methods.removeChar = (id, done) ->
  @chars.pull id
  @save (err, data) -> done err, data

module.exports = mongoose.model 'User', User
