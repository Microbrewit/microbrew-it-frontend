mbit = angular.module('Microbrewit')

mbit.directive('mbCalcBitterness', (bitternessCalc) ->
	return {
		restrict: 'EA'
		scope: {
			'ingredient': '='
			'bitterness': '@bitterness'
			'unit': '@unit'
		}
		replace: true
		template: '<span class="bitterness">{{bitterness}} {{unit}}</span>'
		link: (scope, element, attrs) ->
			# Hop object:
			# boilTime
			# boilVolume
			# amount
			# aa
			# boilGravity
			calcBitterness = () ->
				scope.bitterness = 0
				scope.unit = 'ibu'
				console.log attrs
				formula = if attrs.formula then attrs.formula else 'tinseth'
				calcObj =
					boilTime: parseFloat(attrs.boiltime)
					boilVolume: parseFloat(attrs.boilvolume)
					boilGravity: parseFloat(attrs.boilgravity)
					amount: parseFloat(scope.ingredient.amount)
					aa: parseFloat(scope.ingredient.aa)

				console.log calcObj

				bitternessObj = bitternessCalc[formula](calcObj) if bitternessCalc[formula]?

				scope.bitterness = bitternessObj.ibu.toFixed(2)

				console.log bitternessObj

				scope.ingredient.ibu = bitternessObj.ibu
				scope.ingredient.utilisation = bitternessObj.utilisation
				scope.ingredient.mgl = bitternessObj.mgl

			# Run only once every $digest
			scope.$watch(->
				return [attrs.boilTime, attrs.boilVolume, attrs.boilGravity, scope.ingredient.amount, scope.ingredient.aa, attrs.formula]
			, calcBitterness, true)
	}
)