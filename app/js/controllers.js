'use strict';

/* Controllers */


angular.module('microbrewit.controllers', []).
  controller('BeerCtrl', [function($scope) {
  	$scope.title = "Brun Bjarne";
  }]).
  controller('RegisterCtrl', function($scope) {
  }).
  controller('BreweryCtrl', [function($scope) {
  }]).
  controller('RecipeCtrl', function($scope) {
	$scope.beerName = "Brun Bjarne v2";
	$scope.forkOf = "Brun Bjarne";
  });