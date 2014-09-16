'use strict';
var mountFolder = function (connect, dir) {
	return connect.static(require('path').resolve(dir));
};

module.exports = function (grunt) {
	// show elapsed time at the end
	require('time-grunt')(grunt);
	// load all grunt tasks
	require('load-grunt-tasks')(grunt);

	// load config
	var config = grunt.file.readJSON('microbrew-it.json');

	var jsFiles = config.build.dependencies;
	var port = config.development.port;
	var sourceFolder = config.build.source;
	var buildFolder = config.build.destination;

	var tmpFolder = "tmp";

	
	grunt.initConfig({

		// run several tasks in parallel
		concurrent: {
			target: {
				tasks: ['connect', 'watch:source'],
				options: {
					logConcurrentOutput: true
				}
			}
		},

		// local image minifier
		imagemin: {
			options: {
				optimizationLevel: 0,
				pngquant: true,
				progressive: true
			},
			files: [{
				expand: true,                  // Enable dynamic expansion
				cwd: 'app/',                   // Src matches are relative to this path
				src: ['**/*.{png,jpg,gif}'],   // Actual patterns to match
				dest: buildFolder              // Destination path prefix
			}]
		},

		'sftp-deploy': {
			build: {
				auth: {
					host: config.autoDeploy.host,
					port: config.autoDeploy.port,
					authKey: config.autoDeploy.key
				},
				cache: 'sftpCache.json',
				src: config.autoDeploy.src,
				dest: config.autoDeploy.path,
				exclusions: ['/build/core', 'build/Application.js', 'build/Application.js.map', 'build/build.map.js'],
				serverSep: '/',
				concurrency: 4,
				progress: true
			}
		},
		
		// The Coffeescript compiler
		coffee: {
			compile: {
				options: {
					bare: true,
					sourceMap: true
				},
				files: [{
					expand: true,					// Enable dynamic expansion
					cwd: 'app/coffee',					// Src matches are relative to this path
					src: ['**/*.coffee'],			// Actual patterns to match
					dest: tmpFolder + '/js',  
					ext: '.js'               // Destination path prefix
				}]
			},
			develop: {
				options: {
					bare: true,
					sourceMap: true ,
					join: false
				},
				files: [{
					expand: true,					// Enable dynamic expansion
					cwd: 'app/coffee',					// Src matches are relative to this path
					src: ['**/*.coffee'],			// Actual patterns to match
					dest: buildFolder,  
					ext: '.js'               // Destination path prefix
				}]
			}
		},

		sass: {
			options: {},
			prod: {
				options: {
					outputStyle: 'compressed'
				},
				files: {
					'<%= prodFolder %>/css/main.css' : '<%= tmpFolder %>/scss/main.scss'
				}
			},
			develop: {
				options: {
					outputStyle: 'nested'
				},
				files: {
					'build/main.css' : 'tmp/scss/main.scss'
				}
			}
		},
		
		uglify: {
			options: {
				report: false,
				mangle: true,
				compress: true,
				sourceMap: function (path) {
					return path.replace(/build\/(.*).min.js/, "build/$1.map.js");
				},
				sourceMappingURL: function (path) {
					return path.replace(/build\/(.*).min.js/, "build/$1.map.js");
				}
			},
			prod: {
				files: {
					'build/build.min.js': ['build/build.js']
				}
			}
		},

		clean: {
			src: ["build/**/*", "tmp/**/*"],
			filter: 'isFile'
		},

		// server (node)
		connect: {
			options: {
				port: port,
				hostname: '*',
				keepalive: true,
				protocol: 'http'
			},
			test: {
				options: {
					middleware: function (connect) {
						return [
							mountFolder(connect, './build')
						];
					}
				}
			}
		},

		watch: {
			source: {
				files: ['app/**/*.*'],
				options: {
					spawn: false,
					interrupt: true
				}
			}
		},

		compass: {
			dev: {                    // Another target
				options: {
					sassDir: 'app/sass',
					cssDir: 'build/css'
				}
			}
		},

		copy: {
			html: {
				files: [ {expand: true, cwd: 'app/', src: ['**/*.html'], dest: 'build/', filter: 'isFile'} ]	
			},
			images: {
				files: [ {expand: true, cwd: 'app/', src: ['**/*.{png,jpg,jpeg,gif}'], dest: 'build/', filter: 'isFile'} ]	
			}
		},

		concat: {
			options: {
				separator: '\n',
				stripBanners: true,
				block: true,
				line: true
			},
			sass: {
				src: 'app/sass/**/*.scss',
				dest: tmpFolder + '/scss/main.scss',
				nonull: true
			},
			source: {
				src: jsFiles,
				dest: buildFolder + '/build.js',
				nonull: true
			}
		}
	});

	// fires when any watched file is updated
	grunt.event.on('watch', function(action, filepath, target) {

		grunt.log.subhead('## ' + target + ': ' + filepath + ' has ' + action + ' ##');

		// turn on --force
		grunt.task.run('usetheforce_on');

		// find filename and extention
		var fileExt = filepath.split('.');
		fileExt = fileExt[fileExt.length-1];
	
		if(fileExt === "coffee") {
			grunt.log.writeln('#### DETECTED COFFEE CHANGE - COMMENCING REBUILD ####');
			// run coffee only on changed files, for some reason coffee needs exact filepath in order to be able to write the file

			grunt.task.run('coffee', 'coffee:develop', 'concat:source', 'uglify:prod');
		}

		else if(fileExt === "scss" || fileExt === "css") {
			grunt.log.writeln('#### DETECTED CSS CHANGE ####');
			grunt.task.run('compass');
		}

		// changed file is a template
		else if(fileExt === "html") {
			grunt.log.writeln('#### DETECTED TEMPLATE CHANGE ####');
			grunt.task.run('copy:html')
		}

		// if changed file is an asset
		else if(filepath.indexOf('images') !== -1) {
			grunt.log.writeln('#### DETECTED IMAGE ASSET CHANGE ####');
			// grunt.task.run('imagemin');
			grunt.task.run('copy:images');
		}

		if(config.build.autoDeploy) {
			grunt.task.run('sftp-deploy:build');
		}

		// if(action == "added" || action == "deleted") {
		// 	grunt.log.writeln('FILE ' + filepath.toUpperCase() + ' WAS ' + action.toUpperCase() + ': rebuilding');
		// 	grunt.task.run('build');
		// }

		grunt.task.run('hasfailed', 'usetheforce_restore');
	});

	// avoid crash if error in build
	grunt.registerTask('usetheforce_on',
		'force the force option on if needed',
		function() {
			if ( !grunt.option( 'force' ) ) {
			grunt.config.set('usetheforce_set', true);
			grunt.option( 'force', true );
		}
	});
	grunt.registerTask('usetheforce_restore',
		'turn force option off if we have previously set it',
		function() {
		if ( grunt.config.get('usetheforce_set') ) {
			grunt.option( 'force', false );
		}
	});

	// Checks if there are any errors when running tasks in the watcher
	grunt.registerTask('hasfailed', function() {
		if (grunt.fail.errorcount > 0) {
			grunt.warn('Encountered ' + grunt.fail.errorcount + ' errors while running watcher');
			grunt.log.write('\x07'); // beep!
			grunt.fail.errorcount = 0; //overwrite
		}
	});

	grunt.registerTask('build', 'Build Microbrew.it development version (coffee, sass)', ['clean', 'coffee', 'coffee:develop', 'compass', 'concat:source', 'uglify:prod', 'copy:html', 'copy:images' ]);

	grunt.registerTask('deploy', 'Deploy files to SFTP-server.', ['sftp-deploy:build']);

	grunt.registerTask('default', 'Runs develop task and concurrent (watcher + connect).', ['build', 'concurrent']);
};