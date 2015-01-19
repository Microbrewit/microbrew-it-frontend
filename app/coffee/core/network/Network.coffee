# Module for interacting with the API
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network', [])
	# Define the API endpoint
	.value('ApiUrl', 'http://dev.asphaug.io')
	#.value('ClientUrl', 'localhost:3000') # localhost
	.value('ClientUrl', 'beta.microbrew.it') # beta.microbrew.it