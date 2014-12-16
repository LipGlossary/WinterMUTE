"use strict"

# Environment Variables!
dotenv = require("dotenv")
dotenv.load()

# Gulpfile.js
# Require the needed packages
gulp       = require("gulp")
ejs        = require("gulp-ejs")
gutil      = require("gulp-util")
rename     = require("gulp-rename")
stylus     = require("gulp-stylus")
coffee     = require("gulp-coffee")
path       = require("path")
vinylPaths = require("vinyl-paths")

del = livereload = runSequence = findPort = undefined

if process.env.NODE_ENV == "development"
  del         = require("del")
  livereload  = require("gulp-livereload")
  runSequence = require("run-sequence")
  findPort    = require("find-port")

baseAppPath    = path.join(__dirname, "app")
baseStaticPath = path.join(__dirname, ".generated")
baseJsPath     = path.join(baseAppPath, "js")
baseCssPath    = path.join(baseAppPath, "css")
paths =
  cssInput       : path.join(baseCssPath, "main.1")
  cssOutput      : path.join(baseStaticPath, "css")
  coffeeInput    : path.join(baseJsPath, "*.coffee")
  coffeeOutput   : path.join(baseStaticPath, "js")
  cleanPath      : path.join(baseStaticPath, "*")
  ejsPath        : [path.join(baseAppPath, "**", "*.ejs")]
  assetsBasePath : baseAppPath
  assetsPaths: [
    path.join(baseAppPath, "img", "**", "*"),
    path.join(baseAppPath, "fonts", "**", "*"),
    path.join(baseAppPath, "**", "*.html"),
    path.join(baseCssPath, "**", "*.css"),
    path.join(baseJsPath, "**", "*.js")
  ]
  assetsOutput: baseStaticPath

watchPaths =
  css: [
    path.join(baseCssPath, "**", "*.styl*"),
    baseCssPath,
    path.join("**", "*", "*.styl*")
  ]
  coffee : [path.join(baseJsPath, "**", "*.coffee")]
  assets : paths.assetsPaths
  ejs    : paths.ejsPath


#
# Stylus
#

# Get and render all .styl files recursively
gulp.task "stylus", ->
  gulp.src(paths.cssInput).pipe(stylus().on("error", gutil.log).on("error", gutil.beep)).pipe gulp.dest(paths.cssOutput)

#
# Coffee
#
gulp.task "coffee", ->
  gulp.src(paths.coffeeInput)
    .pipe(coffee({bare: true})
      .on("error", gutil.log)
      .on("error", gutil.beep))
    .pipe gulp.dest(paths.coffeeOutput)


#
# EJS
#
gulp.task "ejs", ->
  gulp.src(paths.ejsPath)
  .pipe(ejs().on("error", gutil.log)
    .on("error", gutil.beep))
  .pipe gulp.dest(paths.assetsOutput)

#
# Static Assets
#
gulp.task "assets", ->
  gulp.src(paths.assetsPaths,
    base: paths.assetsBasePath)
  .on("error", gutil.log)
  .on("error", gutil.beep)
  .pipe gulp.dest(paths.assetsOutput)


#
# Clean
#
gulp.task "clean", ->
  gulp.src(paths.cleanPath)
  .pipe(vinylPaths(del))


#
# Watch
#
gulp.task "watch", ->
  gulp.watch(watchPaths.css, ["stylus"]).on("error", gutil.log).on "error", gutil.beep
  gulp.watch(watchPaths.coffee, ["coffee"]).on("error", gutil.log).on "error", gutil.beep
  gulp.watch(watchPaths.assets, ["assets"]).on("error", gutil.log).on "error", gutil.beep
  # gulp.watch(watchPaths.ejs, ["ejs"]).on("error", gutil.log).on "error", gutil.beep
  if livereload
    findPort [35729], (ports) ->
      if ports.length > 0
        server = livereload.listen(silent: true)
        if server
          msg = "[LiveReload] Now listening on port: " + server.port
          gutil.log msg.green
          livereload.changed()
        gulp.watch(path.join(baseStaticPath, "**")).on("error", gutil.log).on("error", gutil.beep).on "change", livereload.changed
      else
        gutil.log "[LiveReload] Can't start LiveReload => ALREADY RUNNING".red
      return

  return

gulp.task "default", ->
  runSequence "clean", [
    "coffee"
    "stylus"
    "assets"
  ]
