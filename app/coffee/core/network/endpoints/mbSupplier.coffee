# Wrapper for Supplier endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbSupplier', [
	'mbGet'
	'mbPost'
	'mbPut'
	'notification'
	(mbGet, mbPost, mbPut, notification) ->
])