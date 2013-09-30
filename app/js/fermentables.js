'use strict';

/* Controllers */


angular.module('microbrewit.fermentables', []).
	config(['$routeProvider', function($routeProvider) {
		$routeProvider.
			when('/fermentables', {templateUrl: 'partials/fermentablesList.html', controller: 'FermentablesListCtrl'});
    		// when('/yeasts/:yeastid', {templateUrl: 'partials/singleYeast.html', controller: 'SingleYeastCtrl'}).
    		// when('/calculators/pitchrate', {templateUrl: 'partials/calculators/pitchrate.html'})
	}]).
	directive('fermentables', function () {
		return {
			restrict: 'EA',
			replace: true,
			templateUrl: 'partials/recipe/fermentables.html',
			link: function(scope, element, attrs, controller) {
				scope.addFermentable = function (step) {
					step.fermentables.push({ amount: 0 });
				}
				scope.removeFermentable = function (fermentable, step) {
					var index = step.fermentables.indexOf(fermentable.fermentable);
					if(index > -1) {
						step.fermentables.splice(index, 1);
					}
				}

				scope.updateFermentable = function (newFermentable, fermentable) {
					fermentable.name = newFermentable.name;
					fermentable.ppg = newFermentable.ppg;
					fermentable.colour = newFermentable.colour;
				}
			}
		}
	}).
	directive('autocalcSrm', function (mbSrmCalc) {
		return function (scope) {
			// scope.fermentable.colourAddition = mbSrmCalc.calc(scope.fermentable.amount, scope.fermentable.colour, 0, scope.$parent.$parent.settings);

			scope.$watch('$parent.step', function () {
				scope.fermentable.colourAddition = Math.round(mbSrmCalc.calc(scope.fermentable.amount, scope.fermentable.colour, 15, scope.$parent.$parent.settings));
			}, true)
		}
	}).
	directive('autocalcGravity', function () {

	}).
	// API interactions
	service('fermentables', function ($http, mbApiUrl) {
		this.getFromAPI = function () {
			var promise;
			var fermentables = {
				async: function () {
					if (!promise) {
						console.log('fetching fermentables');
						promise = $http.jsonp(mbApiUrl + '/fermentables?callback=JSON_CALLBACK', { cache: true }).then(function (response) {
							// sssionStorage.setItem("fermentables", response.data.fermentables);
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
	service('mbSrmCalc', ['mbConversionCalc', function (mbConversionCalc) {
		this.calc = function (weight, lovibond, postBoilVolume, settings) {
			var colour;

			if(settings.units.largeWeight === "lbs") {
				weight = mbConversionCalc.lbToKg(weight);
			}

			if(settings.formula.colour === "morey") {
				colour = this.morey(weight,lovibond,postBoilVolume);
			}
			else if(settings.formula.colour === "daniels") {
				colour = this.daniels(weight,lovibond,postBoilVolume);
			}
			else if(settings.formula.colour === "mosher") {
				colour = this.mosher(weight,lovibond,postBoilVolume);
			}

			if(settings.units.colour === "ebc") {
				colour = this.srmToEbc(colour);
			}
			console.log('weight: ' + weight + ' lovibond: ' + lovibond + ' postBoilVolume: ' + postBoilVolume + ' = colour ' + colour);

			return colour;
		};

		this.srmToEbc = function (srm) {
			return srm*1.97;
		};
		this.ebcToSrm = function (ebc) {
			return ebc/1.97;
		};

		// Malt Color Units weight in lbs., volume of wort (in gal.)
		this.mcu = function (weight, lovibond, postBoilVolume) {
			return (mbConversionCalc.kgToLb(weight)*lovibond/mbConversionCalc.litersToGallons(postBoilVolume));
		};

		// SRM
		this.morey = function (weight, lovibond, postBoilVolume) {
			return 1.4922 * Math.pow(this.mcu(weight, lovibond, postBoilVolume), 0.6859); // most accurate
		};

		// SRM
		this.daniels = function (weight, lovibond, postBoilVolume) {
			return (0.2 * this.mcu(weight, lovibond, postBoilVolume)) + 8.4;
		};
		// SRM
		this.mosher = function (weight, lovibond, postBoilVolume) {
			return (0.3 * this.mcu(weight, lovibond, postBoilVolume)) + 4.7;
		};
	}]).
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
				// fermentable.originCountry = fermentables.grains[i].origin.split('#')[1].split('_').join(' ');
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
				// fermentable.originCountry = fermentables.extracts.dryextracts[i].origin.split('#')[1].split('_').join(' ');
				fermentable.type = 'dry extract';

				$scope.fermentables.push(fermentable);
			}

			for(var i=0;i<fermentables.extracts.liquidextracts.length;i++) {
				var fermentable = fermentables.extracts.liquidextracts[i];
				// fermentable.originCountry = fermentables.extracts.liquidextracts[i].origin.split('#')[1].split('_').join(' ');
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