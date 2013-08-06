'use strict';

/* Controllers */


angular.module('microbrewit.controllers', []).
	controller('MainCtrl', function ($scope, $routeParams, $rootScope, $route, mbUser) {
			$scope.title = "Microbrew.it";

			mbUser.setupUserSession({
				username: "Torstein",
				email: "torstein@gmail.com",
				breweryName: "Thune Hjemmebryggeri",
				settings: {
					units: {
						colour: 'srm',
						bitterness: 'ibu',
						temperature: 'celcius',
						smallWeight: 'grams',
						largeWeight: 'kg',
						liquid: 'liters'
					},
					formulae: {
						colour: 'morey',
						bitterness: 'tinseth',
						abv: 'microbrewit'
					}
				}
			});
			 // if('profile' in $rootScope) {
	   //      console.log('heyo');
	   //    }
	   //      // $routeProvider.when('/', {templateUrl: 'partials/loggedIndex.html'})
	   //      $route.when('/profile', {templateUrl: 'partials/profile.html', controller: 'ProfileCtrl'});
	
		}).
	controller('BreweryCtrl', function () {}).
	controller('LoginCtrl', function ($scope, $rootScope, $http, $location, mbUser) {

		$scope.login = function (mbUser) {
			console.log('logging in, querying: ' + 'http://api.microbrew.it/users/login?username='+$scope.username+'&password='+$scope.password+'&callback=JSON_CALLBACK');
			$http.jsonp('http://api.microbrew.it/users/login?username='+$scope.username+'&password='+$scope.password+'&callback=JSON_CALLBACK', {method: 'GET'}).
				success(function(data, status, headers, config) {
					$rootScope.user = data.user; // set logged user to responded user
					mbUser.setCookie(data.user); // set a cookie with user data

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
	controller('RegisterCtrl', function($scope, $http, $resource, $location, $rootScope, mbUser) {
		

		$scope.username = 'testest';
		$scope.email='tsettes';
		$scope.breweryName='gesgseg';
		$scope.settings= {};
		$scope.password='testst';
		
		$scope.register = function (mbUser) {

			mbUser.register({
				username: $scope.username,
				password: $scope.password,
				email: $scope.email,
				breweryname: $scope.breweryName,
				settings: $scope.settings
			});
		};

			// var User = $resource('http://api.microbrew.it/users/add', {}, {
   //              add: {
   //                  method: 'POST'
   //              },
   //              get: {
   //              },
   //              update: {
   //              }
   //          });

   //          User.add({}, 
			// 	dataObj, 
			// 	function (data) {
			// 		$rootScope.user = data.user;
			// 		$location.path('/profile');
			// 	},
			// 	function () {
			// 		console.log('Register failed');
   //          	}
   //          );
        // };

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