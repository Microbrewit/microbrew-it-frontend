# Wrapper for Glass endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbGlass', [
	'mbGet'
	'mbPost'
	'mbPut'
	'notification'
	(mbGet, mbPost, mbPut, notification) ->
])