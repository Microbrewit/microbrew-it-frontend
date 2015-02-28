# Module for interacting with the API
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network', [])
	# DEV
	.value('ApiUrl', 'http://dev.asphaug.io')
	.value('ClientUrl', 'localhost:3000')

	# TEST
	# .value('ApiUrl', 'http://dev.asphaug.io')
	# .value('ClientUrl', 'beta.microbrew.it')

	# PROD
	#.value('ApiUrl', 'http://api.microbrew.it')
	# .value('ClientUrl', 'microbrew.it')