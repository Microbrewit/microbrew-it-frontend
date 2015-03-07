# Wrapper for Origin endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbOrigin', [
	'mbRequest'
	'notification'
	(mbRequest, notification) ->
		factory = {}
		endpoint = '/origins'
])