mongoose = require 'mongoose'

Exit = mongoose.Schema
  room:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Room'
    required: true
  list: String
  move: String

module.exports = mongoose.model 'Exit', Exit
