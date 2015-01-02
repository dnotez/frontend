'use strict';

module.exports = function(config) {

  config.set({
    autoWatch : false,
    colors: true,

    frameworks: ['jasmine', 'jasmine-matchers'],
    preprocessors: {
      'src/**/*.js': ['coverage']
    },

    reporters: [
      'coverage',
      'nested'
    ],

    coverageReporter: {
      type: 'html',
      dir: 'build/coverage/'
    },

    browsers : ['PhantomJS'],

    plugins : [
        'karma-phantomjs-launcher',
      'karma-jasmine',
      'karma-coverage',
      'karma-nested-reporter',
      'karma-jasmine-matchers'
    ]
  });
};
