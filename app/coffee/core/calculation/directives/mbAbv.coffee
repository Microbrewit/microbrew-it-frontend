# Directive for calculating ABV
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Calculation')
	.directive('mbAbv', ['abv', (abv) ->
		return {
			restrict: 'E'
			scope: {
				'abv': '@abv'
			}
			replace: true
			template: '<span class="abv no-margin no-padding">{{abv}}</span>'
			link: (scope, element, attrs) ->

				calcAbv = (og, fg) ->
					scope.abv = abv.calc(attrs.og, attrs.fg, attrs.formula).toFixed(2)

				# Run only once every $digest
				scope.$watch(->
					return [attrs.og, attrs.fg, attrs.formula]
				, calcAbv, true) 
		}
	])