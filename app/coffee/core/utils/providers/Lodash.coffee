# Lodash wrapper 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Utils')
	.factory('_', ['$window',
		($window) ->
			# place lodash include before angular
			return $window._
	])