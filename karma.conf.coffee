# karma.conf.coffee
module.exports = (config) ->
    config.set
        basePath: './'
        frameworks: ['jasmine']
        plugins : [
            # 'karma-chrome-launcher'
            'karma-phantomjs-launcher'
            'karma-jasmine'
            'karma-junit-reporter'
        ]
        browsers: ['PhantomJS']
        reporters: ['progress', 'junit']
        junitReporter:
            outputFile: 'reports/unit.xml'
            suite: 'unit'
        files: [
            'app/vendor/jquery/dist/jquery.js'
            'app/vendor/underscore/underscore.js'
            'app/vendor/angular/angular.js'
            'app/vendor/angular-mocks/angular-mocks.js'
            'app/vendor/angular-resource/angular-resource.js'
            'app/vendor/angular-local-storage/dist/angular-local-storage.js'
            'app/vendor/angular-bootstrap/ui-bootstrap.js'
            'app/scripts/**/*.js'
        ]
