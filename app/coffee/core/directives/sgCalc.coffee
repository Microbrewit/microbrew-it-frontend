mbit = angular.module('Microbrewit')

mbit.directive('mbGravityCalc', (conversion) ->
	return {
		restrict: 'EA'
		scope: {
            ingredient: '=' #Two-way data binding
            change: '='
            percent: '@percent'
		}
		replace: true
		template: '<span class="gravity">{{ingredient.gravityPoints}} GP ({{percent}}%)</span>'
		link: (scope, element, attrs) ->
			calcPercent = ->
				totalGP = (attrs.og-1)*1000
				if totalGP is 0
					scope.percent = 0
				else
					scope.percent = Math.round((scope.ingredient.gravityPoints/totalGP)*100)

			calcGravity = ->
				console.log attrs.change
				if attrs.type.toLowerCase().indexOf "malt" isnt -1 or attrs.type.toLowerCase().indexOf "grain" isnt -1
					efficiency = parseFloat(attrs.efficiency)/100
				else
					efficiency = 1
				weight = conversion.convert(parseFloat(attrs.amount), attrs.weightunit, 'lbs') # convert to lbs
				ppg = parseFloat(attrs.ppg)
				volume = conversion.convert(parseFloat(attrs.volume), attrs.fluidunit, 'gallons')

				console.log "weight #{weight} ppg #{ppg} volume #{volume}"
				scope.ingredient.gravityPoints = Math.round((weight*ppg*efficiency)/volume)

				scope.change()

			# Run only once every $digest
			scope.$watch(->
				return [attrs.weightUnit, attrs.fluidUnit, attrs.amount, attrs.ppg, attrs.type, attrs.volume, attrs.efficiency]
			, calcGravity, true)

			scope.$watch(->
				return [attrs.og]
			, calcPercent, true)
	}
)