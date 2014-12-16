module.exports = (app, passport) ->

  # normal routes ===============================================================

  # show the home page (will also have our login links)
  app.get '/', (req, res) -> res.render 'index.ejs'

  # LIVE MUTE ====================================
  app.get '/verse', isLoggedIn, (req, res) ->
    res.render 'verse.ejs'

  # LOGOUT =======================================
  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'

  # TUTORIAL PAGES ===============================
  app.get '/tutorial', (req, res) -> res.render 'tutorial.ejs'
  app.get '/proto', (req, res) -> res.render 'proto.ejs'

  # ============================================================================
  # AUTHENTICATE (FIRST LOGIN) =================================================
  # ============================================================================

  # LOGIN ========================================
  # show the login form
  app.get '/login', (req, res) ->
    res.render 'login.ejs',
      message: req.flash 'loginMessage'

  # process the login form
  app.post '/login', passport.authenticate 'login',
    successRedirect : '/verse' # redirect to the secure profile section
    failureRedirect : '/login'
      # redirect back to the signup page if there is an error
    failureFlash : true # allow flash messages

  # SIGNUP =======================================
  # show the signup form
  app.get '/signup', (req, res) ->
    res.render 'signup.ejs',
      message: req.flash 'signupMessage'

  # process the signup form
  app.post '/signup', passport.authenticate 'signup',
    successRedirect : '/verse' # redirect to the secure profile section
    failureRedirect : '/signup'
      # redirect back to the signup page if there is an error
    failureFlash : true # allow flash messages

  # ============================================================================
  # AUTHORIZE (ALREADY LOGGED IN / CHANGE EMAIL & PASSWORD) ====================
  # ============================================================================

  app.get '/change', (req, res) ->
    res.render 'change.ejs',
      message: req.flash 'loginMessage'

  app.post '/change', passport.authenticate 'signup',
    successRedirect : '/verse' # redirect to the secure profile section
    failureRedirect : '/change'
      # redirect back to the signup page if there is an error
    failureFlash : true # allow flash messages

# ==============================================================================
# MIDDLEWARE ===================================================================
# ==============================================================================
# route middleware to ensure user is logged in
isLoggedIn = (req, res, next) ->
  if req.isAuthenticated() then return next()
  res.redirect '/'
