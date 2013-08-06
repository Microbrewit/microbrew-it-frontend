'use strict';

/* Controllers */


angular.module('microbrewit.controllers', []).
	controller('MainCtrl', function ($scope, $routeParams, $rootScope, $route, mbUser) {
			$scope.title = "Microbrew.it";

			mbUser.setupUserSession({
				username: "Torstein",
				email: "torstein@gmail.com",
				breweryName: "Thune Hjemmebryggeri",
				settings: mbUser.standardSettings
			});
			mbUser.destroyUserSession();
		}).
	controller('BreweryCtrl', function () {}).
	controller('LoginCtrl', function ($scope, $rootScope, $http, $location, mbUser) {
		
		// redirect user if logged in
		if($rootScope.user.username) {
			$location.path('/profile');
		}

		// use mbUser service to perform login via AJAX (it handles errors and location.path atm)
		$scope.login = function (mbUser) {
			mbUser.login({
				username: $scope.username,
				password: $scope.password
			});
		};
	}).
	controller('BeerCtrl', function($scope) {
		$scope.title = "Brun Bjarne";
	}).
	controller('RegisterCtrl', function($scope, $http, $resource, $location, $rootScope, mbUser) {
		
		// redirect user if logged in
		if($rootScope.user.username) {
			$location.path('/profile');
		}

		// userObj for test purposes
		$scope.user = {
			username: 'testest',
			email: 'test@test.test',
			breweryName: 'Test Brewery',
			password: 'test'
		}

		$scope.passwordRep = 'test';


		$scope.register = function (mbUser) {
			if($scope.password == $scope.passwordRep) {
				var userObj = $scope.user;
				userObj.settings = mbUser.standardSettings;

				mbUser.register(userObj);
			} else {
				console.log('password !== passwordRep');
			}
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
		$scope.user = $rootScope.user;

		$scope.update = function (mbUser) {
			mbUser.addUpdate($scope.user);
		};

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
  });