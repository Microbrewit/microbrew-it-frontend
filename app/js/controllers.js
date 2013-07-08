'use strict';

/* Controllers */


angular.module('microbrewit.controllers', []).
	controller('BeerCtrl', [function($scope) {
		$scope.title = "Brun Bjarne";
	}]).
	controller('RegisterCtrl', function($scope) {
	}).
	controller('ProfileCtrl', function($scope) {
		$scope.profile = {
			name: "torthu",
			email: "torstein@gmail.com"
		};
	}).
	controller('BreweryCtrl', [function($scope) {
	}]).
	controller('RecipeCtrl', function($scope) {
		$scope.beerName = "Brun Bjarne v2";
		$scope.forkOf = "Brun Bjarne";
	}).
	controller('CalculatorCtrl', function($scope) {
		$scope.abvCalc = {
			og: 1.050,
			fg: 1.010
		};
  });