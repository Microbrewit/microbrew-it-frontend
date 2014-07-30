# Lodash wrapper 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/utils/Lodash', ['angular-md5']).
	factory('_', ['$window',
		($window) ->
			# place lodash include before angular
			return $window._
	])
	.directive('gravatar', (md5) ->
		return {
			restrict: 'E'
			scope: {
				'src': '@src'
				'size': '@size'
			}
			replace: true
			template: '<div class="avatar gravatar"><img src="http://www.gravatar.com/avatar/{{src}}"  class="round" style="width:{{size}};height:{{size}}" alt="" /></div>'
			link: (scope, element, attr) ->
				attr.$observe('src', (current_value) -> scope.src = md5.createHash(current_value.replace(/\s+/g, '').toLowerCase()))
				scope.size = attr.size
		}
	)