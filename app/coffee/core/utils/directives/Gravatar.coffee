# Gravatar Directive
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Utils').directive('gravatar', () ->
	return {
		restrict: 'E'
		scope: {
		}
		replace: true
		template: '<div class="avatar gravatar"><img src="{{url}}" style="width:{{size}};height:{{size}}" alt="" /></div>'
		link: (scope, element, attrs) ->
			scope.size = attrs.size
			console.log 'GRAVATAR'
			attrs.$observe('url', (current_value) ->
				if attrs.url
					console.log 'gotcha'
					scope.url = "#{attrs.url}?d=retro"
				else
					console.log '?'
					scope.url = "http://gravatar.com/avatar/loltrololol?d=mm"
			)
	}
)