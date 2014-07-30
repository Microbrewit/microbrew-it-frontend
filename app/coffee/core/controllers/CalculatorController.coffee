mbit = angular.module('Microbrewit')

mbit.controller('CalculatorController', ['$scope'
	($scope) ->
		console.log 'CalculatorController'
		$scope.abvCalc =
			og: 1.054
			fg: 1.010
])