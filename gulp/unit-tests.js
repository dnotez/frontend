'use strict';

var gulp = require('gulp');

var $ = require('gulp-load-plugins')();

var wiredep = require('wiredep');

gulp.task('compile-tests', function () {
  return gulp.src(['src/{app,components}/**/*.spec.coffee'])
    .pipe($.coffeelint())
    .pipe($.coffeelint.reporter())
    .pipe($.coffee())
    .on('error', function handleError(err) {
      console.error(err.toString());
      this.emit('end');
    })
    .pipe(gulp.dest('build/test'))
    .pipe($.size());

});

gulp.task('test', ['scripts', 'compile-tests'], function () {
  var bowerDeps = wiredep({
    directory: 'bower_components',
    exclude: ['bootstrap-sass-official'],
    dependencies: true,
    devDependencies: true
  });

  var testFiles = bowerDeps.js.concat([
    '.tmp/{app,components}/**/*.js',
    'build/test/{app,components}/**/*.js',
    'src/{app,components}/**/*.spec.js',
    'src/{app,components}/**/*.mock.js'
  ]);

  return gulp.src(testFiles)
    .pipe($.karma({
      configFile: 'karma.conf.js',
      action: 'run'
    }))
    .on('error', function(err) {
      // Make sure failed tests cause gulp to exit non-zero
      throw err;
    });
});
