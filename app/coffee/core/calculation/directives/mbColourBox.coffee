# Directive for generating a colour box
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Calculation')
	.directive('mbColourBox', ['colour', 'convert', (colourCalc, convert) ->
		return {
			restrict: 'EA'
			scope: {
				ingredient: '='
			}
			replace: true
			template: '<span class="gravity" style="display:inline-block;width:39px;height:39px;padding:0;margin:0;border-radius:50%;margin-right: 5px;border:1px solid rgba(0,0,0,0.2);background:rgba({{rgb}},0.8);"></span></div>'
			link: (scope, element, attrs) ->
				
				calcColour = ->
					if attrs.type is "lovibond"
						scope.lovibond = attrs.colour 
						scope.srm = (convert.convert(attrs.colour, 'lovibond', 'srm')).toFixed(1)
						console.log 'converted l to srm'

					else if attrs.type is "srm"
						scope.lovibond = Math.round(convert.convert(attrs.colour, 'srm', 'lovibond'))
						scope.srm = attrs.colour

					console.log 'find rgb'
					scope.rgb = convert.convert(scope.srm, 'srm', 'rgb')

					console.log 'find mcu'
					scope.ingredient.mcu = colourCalc.mcu(attrs.amount, scope.lovibond, attrs.volume).toFixed(2) if scope.ingredient? and attrs.volume?

				scope.lovibond = 0
				# Run only once every $digest
				scope.$watch(->
					return if attrs.volume? then [attrs.type, attrs.colour, attrs.volume, attrs.amount] else [attrs.type, attrs.colour]
				, calcColour, true)
		}
	])