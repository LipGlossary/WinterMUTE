# load all the things we need
LocalStrategy = require('passport-local').Strategy

# load up the user model
User = require '../app/models/user'

module.exports = (passport) ->

  # ============================================================================
  # passport session setup =====================================================
  # ============================================================================
  # required for persistent login sessions
  # passport needs ability to serialize and unserialize users out of session

  # used to serialize the user for the session
  passport.serializeUser (user, done) -> done null, user.id

  # used to deserialize the user
  passport.deserializeUser (id, done) ->
      User.findById id, (err, user) -> done err, user

  # ============================================================================
  # LOCAL LOGIN ================================================================
  # ============================================================================
  passport.use 'login', new LocalStrategy
    # by default, local strategy uses username and password, we will override
    # with email
    usernameField : 'email'
    passwordField : 'password'
    passReqToCallback : true
      # allows us to pass in the req from our route (lets us check if a user is
      # logged in or not)
    (req, email, password, done) ->
      # asynchronous
      process.nextTick ->
        User.findOne { 'email' :  email }, (err, user) ->
          # if there are any errors, return the error
          if err then return done err
          # if no user is found, return the message
          if !user then return done null, false,
            req.flash 'loginMessage', 'No user found.'
          if !user.validPassword password
            return done null, false,
              req.flash 'loginMessage', 'Oops! Wrong password.'
          # all is well, return user
          else return done null, user

  # ============================================================================
  # LOCAL SIGNUP ===============================================================
  # ============================================================================
  passport.use 'signup', new LocalStrategy
    # by default, local strategy uses username and password, we will override
    # with email
    usernameField : 'email'
    passwordField : 'password'
    passReqToCallback : true
      # allows us to pass in the req from our route (lets us check if a user is
      # logged in or not)
    (req, email, password, done) ->
      # asynchronous
      process.nextTick ->
        User.findOne { 'email' :  email }, (err, user) ->
          # if there are any errors, return the error
          if err then return done err
          # check to see if theres already a user with that email
          if (user) then return done(
            null
            false
            req.flash 'signupMessage', 'That email is already taken.'
          )
          else
            # create the user
            newUser = new User();
            newUser.email = email;
            newUser.password = newUser.generateHash password
            newUser.currentChar = 0
            newUser.visible = false
            newUser.room = '000001'
            newUser.save (err) ->
              if err then throw err
              return done null, newUser