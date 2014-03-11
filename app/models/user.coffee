# load the things we need
mongoose = require 'mongoose'
bcrypt   = require 'bcrypt-nodejs'

# define the schema for our user model
userSchema = mongoose.Schema
  email : String
  password : String

# generating a hash
userSchema.methods.generateHash = (password) ->
  return bcrypt.hashSync password, bcrypt.genSaltSync(8), null

# checking if password is valid
userSchema.methods.validPassword = (password) ->
  return bcrypt.compareSync password, @password

# create the model for users and expose it to our app
module.exports = mongoose.model 'User', userSchema
