'use strict';

/* Controllers */


angular.module('microbrewit.fermentables', []).
	config(['$routeProvider', function($routeProvider) {
		$routeProvider.
			when('/fermentables', {templateUrl: 'partials/fermentablesList.html', controller: 'FermentablesListCtrl'});
    		// when('/yeasts/:yeastid', {templateUrl: 'partials/singleYeast.html', controller: 'SingleYeastCtrl'}).
    		// when('/calculators/pitchrate', {templateUrl: 'partials/calculators/pitchrate.html'})
	}]).
	// API interactions
	service('fermentables', function ($http, mbApiUrl) {
		this.getFermentables = function () {
			var promise;
			var fermentables = {
				async: function () {
					if (!promise) {
						console.log('fetching fermentables');
						promise = $http.jsonp(mbApiUrl + '/fermentables?callback=JSON_CALLBACK', {}).then(function (response) {
							sessionStorage.setItem("fermentables", response.data.fermentables);
							return response.data.fermentables;
						});
					}
					return promise;
				}
			};
			return fermentables;
		};

	}).
	service('primingSugar', function () {
		this.dme = function (wantedCarbonation, beerVolume, currentCarbonation) {
			currentCarbonation = currentCarbonation || 0;

			// mDME =  + 1/((0.5 * 0.82 * 0.80 * / beerVolume)/wantedCarbonation-currentCarbonation);

			// wantedCarbonation = currentCarbonation  + 0.5 * 0.82 * 0.80 * mDME / beerVolume;

		};
		this.caneSugar = function (wantedCarbonation, beerVolume, currentCarbonation) {
			currentCarbonation = currentCarbonation || 0;

			// wantedCarbonation = currentCarbonation + 0.5 * canesugar /beerVolume;

			// canesugar = ((wantedCarbonation - currentCarbonation)/0.5)*beerVolume);
			return ((wantedCarbonation - currentCarbonation)/0.5)*beerVolume; // g of sugar
		};
		this.cornsugar = function (wantedCarbonation, beerVolume, currentCarbonation) {
			currentCarbonation = currentCarbonation || 0;
// Cbeer = Cflat-beer + 0.5 * 0.91 * mcorn-sugar / Vbeer
// Cbeer - the final carbonation of the beer (g/l)
// Cflat-beer - the CO2 content of the beer before bottling (g/l)
// mcorn-sugar - the weight of the corn sugar (glucose monohydrate) (g)
// Vbeer - beer volume (l)
		};
	})

	// search yeasts
	controller('FermentablesListCtrl', function ($scope, fermentables, progressbar) {

		progressbar.start();
		fermentables.getFermentables().async().then(function (fermentables) {
			

			progressbar.complete();
			// $scope.yeasts = yeasts.liquidyeasts;
			console.log(fermentables);
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
	controller('SingleFermentableCtrl', function (yeasts) {

	});