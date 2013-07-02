'use strict';

/* Controllers */


angular.module('microbrewit.controllers', []).
  controller('BeerCtrl', [function($scope) {
  	$scope.title = "Brun Bjarne";

  }]).
  controller('RegisterCtrl', function($scope) {
	  $scope.email = "Torstein@gmail.com";

  }).
  controller('BreweryCtrl', [function($scope) {
  	// $scope.email = "Test@gmail.com";

  }]);