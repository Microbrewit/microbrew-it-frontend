# Directive for calculating Bitterness
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Calculation')
	.directive('mbBitterness', ['bitterness', 'convert', (bitterness, convert) ->
		return {
			restrict: 'E'
			scope: {
				'ingredient': '='
				'bitterness': '@bitterness'
				'unit': '@unit'
				'change': '='
			}
			replace: true
			template: '<span class="bitterness">{{bitterness}} {{unit}} - {{ingredient.utilisation}} utilisation - {{ingredient.mgl}} mgl</span>'
			link: (scope, element, attrs) ->
				# Hop object:
				# boilTime
				# boilVolume
				# amount
				# aa
				# boilGravity
				calcBitterness = () ->
					scope.unit = 'ibu' unless scope.unit?
					formula = if attrs.formula then attrs.formula else 'tinseth'

					# Generate HopObj
					calcObj =
						boilTime: parseFloat(attrs.boiltime)
						boilVolume: parseFloat(attrs.boilvolume)
						boilGravity: parseFloat(attrs.boilgravity)
						amount: parseFloat(scope.ingredient.amount)
						aa: parseFloat(scope.ingredient.aa)

					# Generate bitternessObj (mgl, utilisation, ibu)
					bitternessObj = bitterness[formula](calcObj)

					# Set scope bitterness with whatever unit is active
					scope.bitterness = convert.convert(bitternessObj.ibu, 'ibu', scope.unit).toFixed(2)

					# Set values on ingredient if we have an ingredient
					if scope.ingredient?
						scope.ingredient.ibu = bitternessObj.ibu
						scope.ingredient.utilisation = bitternessObj.utilisation.toFixed(4)
						scope.ingredient.mgl = bitternessObj.mgl

					# Call change function if we have one
					if scope.change?
						scope.change()

				# Run only once every $digest
				scope.$watch(->
					return [attrs.boiltime, attrs.boilvolume, attrs.boilgravity, scope.ingredient.amount, scope.ingredient.aa, attrs.formula]
				, calcBitterness, true)
		}
	])