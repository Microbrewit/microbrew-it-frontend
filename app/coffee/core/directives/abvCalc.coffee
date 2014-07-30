mbit = angular.module('Microbrewit')

mbit.directive('mbCalcAbv', (abvCalc) ->
	return {
		restrict: 'EA'
		scope: {
			'formula': '@formula'
			'abv': '@abv'
		}
		replace: true
		template: '<div class="abv">{{abv}}% ({{formula}})</div>'
		link: (scope, element, attr) ->
			formulaToUse = ""

			calcAbv = (og, fg) ->
				abvCalc[formulaToUse](og, fg) if abvCalc[formulaToUse]?

			attr.$observe('formula', (formula) ->
				formulaToUse = formula
				scope.formula = formula
			)

			attr.$observe('og', (og) ->
				abv = calcAbv(og, attr.fg)
				scope.abv = abv.toFixed(2) if typeof abv is 'number' 
			)

			attr.$observe('fg', (fg) ->
				abv = calcAbv(attr.og, fg) 
				scope.abv = abv.toFixed(2) if typeof abv is 'number' 
			)    	
	}
)