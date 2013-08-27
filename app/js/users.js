'use strict';

/* Controllers */


angular.module('microbrewit.users', []).
	controller('LoginCtrl', function ($scope, $http, $location, mbUser) {
		// redirect user if logged in
		if(typeof $scope.user !== "undefined" && $scope.user.isLogged) {
			$location.path('/profile');
		}

		$scope.loginObj = {};

		// use mbUser service to perform login via AJAX (it handles errors and location.path atm)
		$scope.login = function () {
			mbUser.login($scope.loginObj).async().then(function (userObj) {
				console.log('LOGINCTRL: ')
				console.log(userObj);
				mbUser.setupUserSession(userObj);
				$location.path('/');
			});
		};
	}).
	controller('LogoutCtrl', function($scope, $location, mbUser) {
		$scope.logout = function () {
			mbUser.logout().async().then(function (logoutObj) {
				if(logoutObj.error) {
					console.log(logoutObj);
				}
				mbUser.destroyUserSession();
				$location.path('/');
			}, function (logoutObj) {
				mbUser.destroyUserSession();
				$location.path('/');
			});
		}
	}).
	controller('RegisterCtrl', function($scope, $location, mbUser) {
		// redirect user if logged in
		if($scope.isLogged === true) {
			$location.path('/profile');
		}

		$scope.registerObj = {
			username: '',
			name: '',
			avatar: '',
			location: '',
			age: 0,
			gender: '',
			password: '',
			email: '',
			breweryname: '',
			settings: mbUser.standardSettings
		}

		$scope.passwordRep = '';


		$scope.register = function () {
			if($scope.registerObj.password == $scope.passwordrep) {
				var registerObj = $scope.registerObj;

				mbUser.register(registerObj).async().then(function(userObj) {
					console.log('USEROBJ');
					console.log(userObj);
					mbUser.setupUserSession(userObj);
					$location.path('#/profile');
				});

			} else {
				console.log('password !== passwordrep');
			}
		};
	}).
	controller('ProfileCtrl', function($scope, $rootScope, $location) {
		$scope.user = $rootScope.user;

		if(typeof $scope.user === "undefined" || !$scope.user.isLogged){
			$location.path('/login');
		} else {
			$scope.update = function (mbUser) {
				mbUser.addUpdate($scope.user);
			};
		}
	}).
	service('mbUser', function ($cookies, $cookieStore, $rootScope, $http, progressbar, mbApiUrl) {

		this.register = function (userObj) {
			$http.defaults.useXDomain = true;
			var promise;
			var returnUserObj = {
				async: function () {
					console.log(userObj);
					if (!promise) {
						console.log('registering user');
						promise = $http.post( + '/users', {
							username: userObj.username,
							name: userObj.name,
							avatar: userObj.avatar,
							location: userObj.location,
							age: userObj.age,
							gender: userObj.gender,
							password: userObj.password,
							email: userObj.email,
							breweryname: userObj.breweryname,
							settings: userObj.settings
						}).error(function(response, status, headers, config) {
							console.log('REGISTER ERROR');
							console.log(response);
							console.log(config);
							progressbar.message(response.error.message + ' (' + response.error.code + ').', '#DE5C5C');
						}).then(function (response) {
							console.log('RESPONSE:');
							console.log(response.data.users[0]);
							return response.data.users[0][0];
						});
					}
					return promise;
				}
			};
			return returnUserObj;
		};

		this.standardSettings = {
			units: {
				colour: 'srm',
				bitterness: 'ibu',
				temperature: 'celcius',
				smallWeight: 'grams',
				largeWeight: 'kg',
				liquid: 'liters'
			},
			formula: {
				colour: 'morey',
				bitterness: 'tinseth',
				abv: 'microbrewit'
			},
			mashVolume: 20,
			efficiency: 70
				
		};
		// takes in a userObj that you want to add to the user db in the API
		this.update = function (userObj) {
		};

		this.login = function (userObj) {
			$http.defaults.useXDomain = true;
			var promise;
			var returnUserObj = {
				async: function () {
					if (!promise) {
						promise = $http.post(mbApiUrl + '/users/login/', {id:userObj.username,password:userObj.password}).
						error(function(response, status, headers, config) {
							console.log(response);
							progressbar.message(response.error.message + ' (' + response.error.code + ').', '#DE5C5C');
						}).then(function (response) {
							console.log('LOGIN response: ');
							var userObj = response.data.users[0];
							console.log(userObj);
							return userObj;
						});
					}
					return promise;
				}
			};
			return returnUserObj;
		};

		this.logout = function () {
			$http.defaults.useXDomain = true;
			var promise;
			var logoutObj = {
				async: function () {
					if (!promise) {
						promise = $http.get(mbApiUrl + '/users/logout').
						error(function(response, status, headers, config) {
							if(response.error.code == "U104" || response.error.code === 0) {
								destroyUserSession();
								logoutObj = response;
								return logoutObj;
							} else {
								progressbar.message(response.error.message + ' (' + response.error.code + ').', '#DE5C5C');
							}
						}).then(function (response) {
							console.log('LOGOUT response: ');
							var logoutObj = response;
							return logoutObj;
						});
					}
					return promise;
				}
			};
			return logoutObj;
		};

		this.setupUserSession = function (userObj) {
			console.log('SETUP USER DATA');
			console.log(userObj);
			this.setCookie(userObj);
			$rootScope.user = userObj;
			$rootScope.user.isLogged = true;
		};

		this.destroyUserSession = function () {
			this.removeCookie();
			$rootScope.user = {};
			$rootScope.user.isLogged = false;
		};

		function destroyUserSession() {
			$cookieStore.remove('mb_user');
			$rootScope.user = {};
			$rootScope.user.isLogged = false;
		};

		this.isLogged = function () {
			// do we have a user cookie?
			if($cookieStore.get('mb_user')) {
				return true;
			}

			// do we have a user object?
			else if(typeof $rootScope.user !== "undefined" && $rootScope.user.username) {
				return true;
			}

			return false;
		};

		this.getDetailsFromCookie = function () {
			return $cookieStore.get('mb_user');
		};

		this.setCookie = function (userObj) {
			$cookieStore.put('mb_user', userObj);
		};

		this.removeCookie = function () {
			$cookieStore.remove('mb_user');
		};
	});