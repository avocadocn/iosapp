var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var concat = require('gulp-concat');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');
var stylus = require('gulp-stylus');
var watch = require('gulp-watch');
var jade = require('gulp-jade');

var paths = {
  jade: ['./jade/**/*.jade'],
  stylus: ['./stylus/**/*.styl']
};

gulp.task('default', ['stylus', 'jade']);
gulp.task('fullwatch', ['stylus', 'jade:compile', 'watch:jade']);

gulp.task('stylus', function (done) {
  gulp.src(paths.stylus)
    .pipe(watch(paths.stylus))
    .pipe(stylus())
    .pipe(gulp.dest('./www/css/'))
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(rename({ extname: '.min.css' }))
    .pipe(gulp.dest('./www/css/'))
    .on('end', done);
});

gulp.task('jade', function (done) {
  gulp.src(paths.jade)
    .pipe(watch(paths.jade))
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest('./www/'))
    .on('end', done);
});

gulp.task('jade:compile', function(done) {
  gulp.src(paths.jade)
    .pipe(jade({
      pretty: true
    }))
    .pipe(gulp.dest('./www/'))
    .on('end', done);
});

gulp.task('watch:jade', function() {
  gulp.watch(paths.jade, ['jade:compile']);
});

gulp.task('install', ['git-check'], function () {
  return bower.commands.install()
    .on('log', function(data) {
      gutil.log('bower', gutil.colors.cyan(data.id), data.message);
    });
});

gulp.task('git-check', function (done) {
  if (!sh.which('git')) {
    console.log(
      '  ' + gutil.colors.red('Git is not installed.'),
      '\n  Git, the version control system, is required to download Ionic.',
      '\n  Download git here:', gutil.colors.cyan('http://git-scm.com/downloads') + '.',
      '\n  Once git is installed, run \'' + gutil.colors.cyan('gulp install') + '\' again.'
    );
    process.exit(1);
  }
  done();
});
