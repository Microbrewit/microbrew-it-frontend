#°L = (SRM + 0.6) / 1.35

mbit = angular.module('Microbrewit')

mbit.directive('mbColourBox', ['srmToRgb', (srmToRgb) ->
	return {
		restrict: 'EA'
		scope: {
			ingredient: '=',
			lovibond: '@lovibond',
			srm: '@srm'
		}
		replace: true
		template: '<div><div style="float:left;">{{lovibond}}°L<br /> {{srm}} srm</div> <span class="gravity" style="display:inline-block;width:40px;height:40px;border:1px solid rgba(0,0,0,0.2);background:rgba({{rgb}},0.8);"></span></div>'
		link: (scope, element, attrs) ->
			
			calcColour = ->
				if attrs.type is "lovibond"
					scope.lovibond = attrs.colour 
					scope.srm = (attrs.colour*1.35-0.6).toFixed(1)

				else if attrs.type is "srm"
					scope.lovibond = Math.round((attrs.colour+0.6)/1.35)
					scope.srm = attrs.colour

				scope.rgb = srmToRgb(scope.srm)

				# Add 
				scope.ingredient.mcu = (((attrs.amount*2.205)*scope.lovibond)/attrs.volume*0.264).toFixed(2) if scope.ingredient? and attrs.volume?
					

			# Run only once every $digest
			scope.$watch(->
				return if attrs.volume? then [attrs.type, attrs.colour, attrs.volume, attrs.amount] else [attrs.type, attrs.colour]
			, calcColour, true)
	}
])