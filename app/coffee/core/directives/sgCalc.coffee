mbit = angular.module('Microbrewit')

mbit.directive('mbGravityCalc', () ->
	return {
		restrict: 'EA'
		scope: {
            ingredient: '=' #Two-way data binding
		}
		replace: true
		template: '<span class="gravity">{{ingredient.gravityPoints}}</span>'
		link: (scope, element, attrs) ->

			calcGravity = ->
				if attrs.type.toLowerCase().indexOf "malt" isnt -1 or attrs.type.toLowerCase().indexOf "grain" isnt -1
					efficiency = parseFloat(attrs.efficiency)/100
				else
					efficiency = 1

				weight = parseFloat(attrs.amount)*2.2046 # convert to lbs
				ppg = parseFloat(attrs.ppg)
				volume = parseFloat(attrs.volume)
				
				scope.ingredient.gravityPoints = Math.round((weight*ppg*efficiency)/volume)

			# Run only once every $digest
			scope.$watch(->
				return [attrs.amount, attrs.ppg, attrs.type, attrs.volume, attrs.efficiency]
			, calcGravity, true)
	}
)