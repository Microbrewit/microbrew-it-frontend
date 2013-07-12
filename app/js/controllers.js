'use strict';

/* Controllers */


angular.module('microbrewit.controllers', []).
  controller('MainCtrl', function($scope, $routeParams) {
    $scope.title = "Microbrew.it";
  }).
	controller('BeerCtrl', function($scope) {
		$scope.title = "Brun Bjarne";
	}).
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
  }).
  controller('SrmCtrl', function($scope, mbSrmCalc) {


    $scope.addMalt = function () {
		this.malts.push({name:"", lovibond: 0, weight: 0});
    };
	$scope.removeMalt = function (scope, elem, attr) {
		var hashKey = this.malt.$$hashKey;
		$scope.malts = _($scope.malts).reject(function(el) { return el.$$hashKey !== hashKey; });
	};

	$scope.$watch('malts', function(malts, oldMalts) {
		var srm = 0;
		for(var i = 0;i<malts.length;i++) {
			srm += mbSrmCalc.morey(malts[i].weight, malts[i].lovibond, 20);
		}

		if($scope.formula == "ebc") {
			srm = mbSrmCalc.srmToEbc(srm);
		}
		$scope.srm = srm.toFixed(2);
	}, true);
	$scope.$watch('formula', function(formula) {
		if(formula == "ebc") {
			$scope.srm = mbSrmCalc.srmToEbc($scope.srm);
		} else if(formula == "srm") {
			$scope.srm = mbSrmCalc.ebcToSrm($scope.srm);
		}
	});
	$scope.formula = "srm";
	$scope.srm = 0;
	$scope.volume = 20;
	$scope.malts = [{name:"", lovibond: 0, weight: 0},{name:"", lovibond: 0, weight: 0}];
  });