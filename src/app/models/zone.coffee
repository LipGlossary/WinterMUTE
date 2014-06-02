mongoose = require 'mongoose'

Zone = mongoose.Schema
  owner:
    type: mongoose.Schema.Types.ObjectId
    ref: 'Char'
    required: true
  name:
  	type     : String
  	unique   : true
  	required : true
  code :
    type     : String
    required : true
    unique   : true
  parent :
    type : mongoose.Schema.Types.ObjectId
    ref  : 'Zone'
  private :
    type : Boolean
    required : true
  zones: [
    type: mongoose.Schema.Types.ObjectId
    ref: 'Zone'
  ]
  rooms: [
    type: mongoose.Schema.Types.ObjectId
    ref: 'Room'
  ]

Zone.methods.addZone = (id, done) ->
  @zones.push id
  @save (err, data) -> done err, data

Zone.methods.removeZone = (id, done) ->
  @zones.pull id
  @save (err, data) -> done err, data

module.exports = mongoose.model 'Zone', Zone
