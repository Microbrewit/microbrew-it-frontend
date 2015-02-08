# Directive for generating a colour box
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Calculation')
	.directive('mbGravity', ['convert', '_', (convert, _) ->
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
					if (attrs.type.toLowerCase().indexOf "malt" isnt -1 or attrs.type.toLowerCase().indexOf "grain" isnt -1)
						efficiency = parseFloat(attrs.efficiency)/100
					else
						efficiency = 1
					
					efficiency = 1 if isNaN(efficiency)

					weight = convert.convert(parseFloat(attrs.amount), attrs.weightunit, 'lbs') # convert to lbs

					ppg = parseFloat(scope.ingredient.ppg)

					if isNaN(ppg)
						ppg = parseFloat(scope.ingredient.pgg)

					volume = convert.convert(parseFloat(attrs.volume), attrs.fluidunit, 'gallons')

					console.log weight + ' ' + ppg + ' ' + efficiency + ' ' + volume
					scope.ingredient.gravityPoints = Math.round((weight*ppg*efficiency)/volume)


					scope.change?()

				# Run only once every $digest
				scope.$watch(->
					return [attrs.weightUnit, attrs.fluidUnit, attrs.amount, attrs.ppg, attrs.type, attrs.volume, attrs.efficiency]
				, calcGravity, true)

				scope.$watch(->
					return [attrs.og]
				, calcPercent, true)
		}
	])