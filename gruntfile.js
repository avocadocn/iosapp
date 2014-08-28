'use strict';

module.exports = function(grunt) {
    // Project Configuration
    grunt.initConfig({

        watch: {
            stylus: {
                files: ['www/css/*.styl'],
                tasks: ['stylus']
            }
        },

        stylus: {
            compile: {
                options: {
                    urlfunc: 'embedurl',
                    compress: false
                },
                files: [{
                    expand: true,
                    cwd: 'www/css/',
                    src: '*.styl',
                    dest: 'www/css/',
                    ext: '.css'
                }]
            }
        }
    });

    require('load-grunt-tasks')(grunt);

    //Making grunt default to force in order not to break the project.
    grunt.option('force', true);

    //Default task(s).

    grunt.registerTask('default', ['stylus', 'watch']);

};


