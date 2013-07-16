'use strict';

/* Controllers */


angular.module('microbrewit.controllers', []).
	controller('MainCtrl', function ($scope, $routeParams, $rootScope, $route, user) {
			$scope.title = "Microbrew.it";
			console.log(user.isLogged());
			console.log(user.getDetails());
			 // if('profile' in $rootScope) {
	   //      console.log('heyo');
	   //    }
	   //      // $routeProvider.when('/', {templateUrl: 'partials/loggedIndex.html'})
	   //      $route.when('/profile', {templateUrl: 'partials/profile.html', controller: 'ProfileCtrl'});
	
		}).
	controller('LoginCtrl', function ($scope, $rootScope, $http, $location) {

		$scope.login = function (user) {
			console.log('logging in, querying: ' + 'http://betelgeuse.snorre.io:3000/user/login?username='+$scope.username+'&password='+$scope.password+'&callback=JSON_CALLBACK');
			$http.jsonp('http://betelgeuse.snorre.io:3000/user/login?username='+$scope.username+'&password='+$scope.password+'&callback=JSON_CALLBACK', {method: 'GET'}).
				success(function(data, status, headers, config) {
					$rootScope.user = data.user; // set logged user to responded user
					user.setCookie(data.user); // set a cookie with user data

					$location.path('/');

				}).
				error(function(data, status, headers, config) {
					console.log(data);
					console.log(status);
					console.log(headers);
					console.log(config);
				});
		};
		$rootScope.profileSettings = {
			name: '',
			email: '',
			gravatar: '',

		};
	}).
	controller('BeerCtrl', function($scope) {
		$scope.title = "Brun Bjarne";
	}).
	controller('RegisterCtrl', function($scope) {
	}).
	controller('ProfileCtrl', function($scope, $rootScope) {
		console.log($rootScope.user);
		$scope.profile = $rootScope.user;
		console.log($scope.user);


		// $scope.profile = {
		// 	name: "torthu",
		// 	email: "torstein@gmail.com"
		// };
	}).
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