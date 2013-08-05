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
	controller('BreweryCtrl', function () {}).
	controller('LoginCtrl', function ($scope, $rootScope, $http, $location) {

		$scope.login = function (user) {
			console.log('logging in, querying: ' + 'http://api.microbrew.it/users/login?username='+$scope.username+'&password='+$scope.password+'&callback=JSON_CALLBACK');
			$http.jsonp('http://api.microbrew.it/users/login?username='+$scope.username+'&password='+$scope.password+'&callback=JSON_CALLBACK', {method: 'GET'}).
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
	controller('RegisterCtrl', function($scope, $http) {
		$scope.register = function (user) {
			var dataObj = {
				id: $scope.username,
				password: $scope.password,
				email: $scope.email,
				breweryName: $scope.breweryName,
				settings: $scope.settings,
				callback: JSON_CALLBACK
			};

			console.log(dataObj);

			$http.post('http://api.microbrew.it/users/add?', 
				{method: 'POST'},
				dataObj
				).
				success(function(data, status, headers, config) {
					$rootScope.user = data.user; // set logged user to responded user
					user.setCookie(data.user); // set a cookie with user data

					$location.path('/');
					console.log($rootScope.user);

				}).
				error(function(data, status, headers, config) {
					console.log(data);
					console.log(status);
					console.log(headers);
					console.log(config);
				});
		};
	}).
	controller('ProfileCtrl', function($scope, $rootScope) {
		console.log($rootScope.user);
		$scope.profile = $rootScope.user;
		console.log($scope.user);

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

  });