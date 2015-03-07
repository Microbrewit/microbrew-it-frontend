# Wrapper for BeerStyle endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbBeerStyle', [
	'mbRequest'
	'notification'
	(mbRequest, notification) ->
		factory = {}
		endpoint = "/beerstyles"
		
])