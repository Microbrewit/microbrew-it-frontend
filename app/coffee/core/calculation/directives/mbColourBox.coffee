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
			replace: false
			template: '<span class="gravity" style="display:inline-block;width:{{size}};height:{{size}};padding:0;margin:0;border-radius:50%;border:1px solid rgba(0,0,0,0.2);background:rgba({{rgb}},1);"></span>'
			link: (scope, element, attrs) ->

				if attrs.size?
					scope.size = attrs.size
				else
					scope.size = "39px"
				
				calcColour = ->
					if attrs.absolutecolour?
						scope.rgb = attrs.absolutecolour
					else	
						if attrs.type is "lovibond"
							scope.lovibond = attrs.colour 
							scope.srm = (convert.convert(attrs.colour, 'lovibond', 'srm')).toFixed(1)

						else if attrs.type is "srm"
							scope.lovibond = Math.round(convert.convert(attrs.colour, 'srm', 'lovibond'))
							scope.srm = attrs.colour

						scope.rgb = convert.convert(scope.srm, 'srm', 'rgb')

						scope.ingredient.mcu = colourCalc.mcu(convert.convert(attrs.amount, attrs.weightunit, 'kg'), scope.lovibond, convert.convert(attrs.volume, attrs.liquidunit, 'liters')).toFixed(2) if scope.ingredient? and attrs.volume?

				scope.lovibond = 0
				# Run only once every $digest
				scope.$watch(->
					return if attrs.volume? then [attrs.type, attrs.colour, attrs.volume, attrs.amount] else [attrs.type, attrs.colour]
				, calcColour, true)
		}
	])