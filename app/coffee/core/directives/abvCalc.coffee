mbit = angular.module('Microbrewit')

mbit.directive('mbCalcAbv', (abvCalc) ->
	return {
		restrict: 'EA'
		scope: {
			'formula': '@formula'
			'abv': '@abv'
		}
		replace: true
		template: '<span class="abv">{{abv}}</span>'
		link: (scope, element, attr) ->
			formulaToUse = ""
			calcAbv = (og, fg) ->
				abv = abvCalc[formulaToUse](og, fg) if abvCalc[formulaToUse]?
				abv = 0 if isNaN(abv)
				return abv

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