# set up ======================================================================
# get all the tools we need
express  = require('express.io')
app      = express().http().io()
port     = process.env.PORT || 8080
mongoose = require('mongoose')
passport = require('passport')
flash    = require('connect-flash')
path     = require('path')

basePath = path.join(__dirname, '..')
configDB = require(path.join(basePath, 'config', 'database'))

# configuration ===============================================================
mongoose.connect configDB.url # connect to our database

require(path.join(basePath, 'config', 'passport'))(passport) # pass passport for configuration

app.configure ->
  # set up our express application
  app.use express.logger('dev')  # log every request to the console
  app.use express.cookieParser() # read cookies (needed for auth)
  app.use express.bodyParser()   # get information from html forms
  app.use express.static(path.join(basePath, '.generated'))

  app.set 'views', path.join(basePath, 'app', 'views')
  app.set 'view engine', 'ejs' # set up ejs for templating

  # required for passport
  app.use express.session(secret: 'buymeaprettyhorse')
    # session secret
  app.use passport.initialize()
  app.use passport.session() # persistent login sessions
  app.use flash() # use connect-flash for flash messages stored in session

# routes ======================================================================
# load our routes and pass in our app and fully configured passport
require('./routes')(app, passport)

# events =======================================================================
require('./events')(app)

# load world ===================================================================
require('./world')()

# launch ======================================================================
app.listen port
console.log "The magic happens on port #{port}"
