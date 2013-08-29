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
		this.getFromAPI = function () {
			var promise;
			var fermentables = {
				async: function () {
					if (!promise) {
						console.log('fetching fermentables');
						promise = $http.jsonp(mbApiUrl + '/fermentables?callback=JSON_CALLBACK', { cache: true }).then(function (response) {
							sessionStorage.setItem("fermentables", response.data.fermentables);
							return response.data.fermentables;
						});
					}
					return promise;
				}
			};
			return fermentables;
		};
		this.getFromCache = function() {

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
	}).

	// search yeasts
	controller('FermentablesListCtrl', function ($scope, fermentables, progressbar) {

		progressbar.start();
		fermentables.getFromAPI().async().then(function (fermentables) {

			// we need to flatten the model, and we need some control of what we add to the objects of the different types of fermentables
			
			$scope.fermentables = [];
			for(var i=0;i<fermentables.grains.length;i++) {
				var fermentable = fermentables.grains[i];
				fermentable.originCountry = fermentables.grains[i].origin.split('#')[1].split('_').join(' ');
				fermentable.type = 'grain';

				$scope.fermentables.push(fermentable);
			}

			for(var i=0;i<fermentables.sugars.length;i++) {
				var fermentable = fermentables.sugars[i];
				// fermentable.originCountry = fermentables.sugars[i].origin.split('#')[1].split('_').join(' ');
				fermentable.type = 'sugar';

				$scope.fermentables.push(fermentable);
			}

			for(var i=0;i<fermentables.extracts.dryextracts.length;i++) {
				var fermentable = fermentables.extracts.dryextracts[i];
				fermentable.originCountry = fermentables.extracts.dryextracts[i].origin.split('#')[1].split('_').join(' ');
				fermentable.type = 'dry extract';

				$scope.fermentables.push(fermentable);
			}

			for(var i=0;i<fermentables.extracts.liquidextracts.length;i++) {
				var fermentable = fermentables.extracts.liquidextracts[i];
				fermentable.originCountry = fermentables.extracts.liquidextracts[i].origin.split('#')[1].split('_').join(' ');
				fermentable.type = 'liquid extract';

				$scope.fermentables.push(fermentable);
			}



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