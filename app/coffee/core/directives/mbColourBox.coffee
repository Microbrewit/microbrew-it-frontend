#°L = (SRM + 0.6) / 1.35

mbit = angular.module('Microbrewit')

mbit.directive('mbColourBox', ['colourCalc', 'conversion', (colourCalc, conversion) ->
	return {
		restrict: 'EA'
		scope: {
			ingredient: '=',
			lovibond: '@lovibond',
			srm: '@srm'
		}
		replace: true
		template: '<div><span class="gravity" style="display:inline-block;width:39px;height:39px;padding:0;margin:0;margin-right: 5px;border:1px solid rgba(0,0,0,0.2);background:rgba({{rgb}},0.8);"></span>{{lovibond}}°L</div>'
		link: (scope, element, attrs) ->
			
			calcColour = ->
				if attrs.type is "lovibond"
					scope.lovibond = attrs.colour 
					scope.srm = (conversion.convert(attrs.colour, 'lovibond', 'srm')).toFixed(1)
					console.log 'converted l to srm'

				else if attrs.type is "srm"
					scope.lovibond = Math.round(conversion.convert(attrs.colour, 'srm', 'lovibond'))
					scope.srm = attrs.colour

				console.log 'find rgb'
				scope.rgb = colourCalc.srmToRgb(scope.srm)

				console.log 'find mcu'
				scope.ingredient.mcu = colourCalc.mcu(attrs.amount, scope.lovibond, attrs.volume).toFixed(2) if scope.ingredient? and attrs.volume?

				# # Add 
				# scope.ingredient.mcu = (((attrs.amount*2.205)*scope.lovibond)/attrs.volume*0.264).toFixed(2) 
					

			# Run only once every $digest
			scope.$watch(->
				return if attrs.volume? then [attrs.type, attrs.colour, attrs.volume, attrs.amount] else [attrs.type, attrs.colour]
			, calcColour, true)
	}
])