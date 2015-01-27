'use strict';

var gulp = require('gulp');

// inject bower components
gulp.task('wiredep', function () {
  var wiredep = require('wiredep').stream;

  return gulp.src('src/index.html')
    .pipe(wiredep({
      directory: 'bower_components',
      exclude: [/foundation\.js/, /foundation\.css/, /bootstrap\.css/, /foundation\.css/, /foundation-icons\.css/]
    }))
    .pipe(gulp.dest('src'));
});
