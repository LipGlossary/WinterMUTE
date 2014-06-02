User = require '../app/models/user'
Char = require '../app/models/char'
Zone = require '../app/models/zone'
Room = require '../app/models/room'

module.exports = ->

  setupUser = (done) ->
    User
    .findOne email : 'admin'
    .exec (err, user1) ->
      if err? then done err, null
      else if user1? then done null, user1
      else 
        user = new User
        user.email       = 'admin'
        user.password    = user.generateHash 'buy me a pretty horse'
        user.currentChar = 0
        user.visible     = false
        user.room        = '000001'
        user.save (err2, user2) ->
          if err2? then done err2, null
          else Char.create
            owner  : user2._id
            name   : 'Lulu'
            list   : 'Lovely Locks'
            look   : "It's rude to stare."
            move   : 'wafts'
            appear : 'in a shower of rose petals'
            (err3, char) ->
              user2.addChar char._id, (err4, user3) ->
                if err3? then done err3, null
                else done null, user2

  setupZone = (user, done) ->
    Zone
    .findOne code : '000000'
    .exec (err, zone) ->
      if err? then done err, null, null
      else if zone? then done null, user, zone
      else Zone.create
        owner   : user._id
        name    : 'The Verse'
        code    : '000000'
        private : false
        (err2, zone2) ->
          if err2? then done err2, null, null
          else done null, user, zone2

  setupRoom = (user, zone, done) ->
    Room
    .findOne code : '000001'
    .exec (err, room) ->
      if err? then done err
      else if room? then done null
      else Room.create
        owner : user._id
        code  : '000001'
        name  : 'The Dressing Room'
        look  : "This long, narrow room resembles a backstage, area, dimly " + \
                "lit with unfinished brick, steel and ductwork painted blac" + \
                "k. Cables, ropes, and wires run from hidden crevace to chi" + \
                "nks in the walls, some working intermittently, some dusty " + \
                "with disuse.\n\nThis isn't to say that the Dressing Room d" + \
                "oesn't have its comforts. The largest stretch of hardwood " + \
                "flooring is covered with a threadbare oriental rug. Two wi" + \
                "de vanities line one wall, and a changing screen is angled" + \
                " into a dark corner. As well as a number of spidery wooden" + \
                " chairs, a well-loved and over-stuffed couch sags beneath " + \
                "the grimy chandelier."
        private : false
        (err2, room2) ->
          if err2? then done err2
          else done null

  console.log "Spinning up the world..."
  setupUser (err, user) ->
    if err? then console.log err
    else setupZone user, (err2, user2, zone) ->
      if err2? then console.log err2
      else setupRoom user2, zone, (err3) ->
        if err3? then console.log err3
        else console.log "OK"