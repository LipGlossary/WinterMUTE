module.exports = (app) ->

  app.io.route 'edit', (req) ->
    console.log req.data

  # req.session.name = req.data
  # req.session.save(function() {
  #     req.io.emit('get-feelings')
  # })