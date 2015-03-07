# Wrapper for RefreshToken endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbRefreshToken', [
	'mbRequest'
	'notification'
	(mbRequest, notification) ->
		factory = {}
		endpoint = '/refreshtoken'
])