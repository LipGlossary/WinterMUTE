mongoose = require 'mongoose'

Char = mongoose.Schema
  name: String
  list: String
  look: String
  move: String
  appear: String

module.exports = mongoose.model 'Char', Char
