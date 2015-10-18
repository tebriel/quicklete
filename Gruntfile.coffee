module.exports = (grunt) ->

    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        watch:
            scripts:
                files: ['source/**/*.coffee', 'api/**/*.coffee']
                tasks: ['clean', 'coffee']

        coffee:
            scripts:
                expand: true
                flatten: true
                cwd: 'source'
                src: ['*.coffee']
                dest: 'app/scripts'
                ext: '.js'
            server:
                expand: true
                flatten: true
                cwd: 'api'
                src: ['*.coffee']
                dest: 'api/scripts'
                ext: '.js'

        clean:
            main: ["app/scripts"]

    # Load the plugin that provides the "uglify" task.
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-watch'

    # Default task(s).
    grunt.registerTask 'default', ['clean', 'coffee']
