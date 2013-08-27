'use strict';

/* Controllers */


angular.module('microbrewit.yeasts', []).
	config(['$routeProvider', function($routeProvider) {
		$routeProvider.
			when('/yeasts', {templateUrl: 'partials/yeast.html', controller: 'YeastListCtrl'}).
    		when('/yeasts/:yeastid', {templateUrl: 'partials/singleYeast.html', controller: 'SingleYeastCtrl'}).
    		when('/calculators/pitchrate', {templateUrl: 'partials/calculators/pitchrate.html'})
	}]).
	// API interactions
	service('yeasts', function ($http, mbApiUrl) {
		this.getYeasts = function () {
			var promise;
			var yeasts = {
				async: function () {
					if (!promise) {
						console.log('fetching hops');
						promise = $http.jsonp(mbApiUrl + '/yeasts?callback=JSON_CALLBACK', {}).then(function (response) {
							sessionStorage.setItem("yeasts", response.data.yeasts);
							return response.data.yeasts;
						});
					}
					return promise;
				}
			};
			return yeasts;
		};

	}).

	// search yeasts
	controller('YeastListCtrl', function ($scope, yeasts, progressbar) {

		progressbar.start();
		yeasts.getYeasts().async().then(function (yeasts) {
			$scope.yeasts = [];
			for(var i=0;i<yeasts.liquidyeasts.length;i++) {
				var yeast = {
					name: yeasts.liquidyeasts[i].name,
					comment: yeasts.liquidyeasts[i].comment,
					productCode: yeasts.liquidyeasts[i].href.split('#')[1].split('_').join(' '),
					id: yeasts.liquidyeasts[i].id,
					suppliedby: yeasts.liquidyeasts[i].suppliedby.split('#')[1],
					type: 'liquid'
				}
				$scope.yeasts.push(yeast);
			}

			for(var i=0;i<yeasts.dryyeasts.length;i++) {
				var yeast = {
					name: yeasts.dryyeasts[i].name,
					comment: yeasts.dryyeasts[i].comment,
					productCode: yeasts.dryyeasts[i].href.split('#')[1].split('_').join(' '),
					id: yeasts.dryyeasts[i].id,
					suppliedby: yeasts.dryyeasts[i].suppliedby.split('#')[1],
					type: 'dry'
				}
				$scope.yeasts.push(yeast);
			}

			$scope.orderProp = "productCode";

			progressbar.complete();
			// $scope.yeasts = yeasts.liquidyeasts;
			console.log(yeasts);
		}, function (error) {
			var message = "";
			if(error.error) {
				message = error.error.message + ' (code: ' + error.error.code + ')';
			} else {
				message = "Could not reach API to fetch yeast information. Try again later.";
			}
			progressbar.message(message);
		});
	}).

	// see info about single yeast
	controller('SingleYeastCtrl', function (yeasts) {

	});