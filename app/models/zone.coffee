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

Zone.methods.addZone = (id) ->
  @update
    $push :
      zones : id
    (err, data) ->
      if err? then req.io.emit 'error', err

Zone.methods.removeZone = (id) ->
  @zones.pull id
  @save (err, data) ->
    if err? then req.io.emit 'error', err

module.exports = mongoose.model 'Zone', Zone
