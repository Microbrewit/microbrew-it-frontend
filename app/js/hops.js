'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('microbrewit.hops', []).
	config(['$routeProvider', function($routeProvider) {
		$routeProvider.
			when('/hops', {templateUrl: 'partials/hops.html', controller: 'HopsCtrl'}).
    		when('/hops/:hopid', {templateUrl: 'partials/hopDetails.html', controller: 'HopDetailsCtrl'}).
    		when('/calculators/bitterness', {templateUrl: 'partials/calculators/bitterness.html'})
	}]).
	service('hops', function ($http, mbApiUrl) {
		this.getHops = function () {
			var promise;
			var hops = {
				async: function () {
					if (!promise) {
						console.log('fetching hops');
						promise = $http.jsonp(mbApiUrl + '/hops?callback=JSON_CALLBACK', {}).then(function (response) {
							// The then function here is an opportunity to modify the response
							sessionStorage.setItem("hops", response.data.hops);
							console.log('!');
							// The return value gets picked up by the then in the controller.
							return response.data;
						});
					}
					return promise;
				}
			};
			return hops;
		};
		this.updateHops = function () {};

	}).
	directive('hops', function () {
		return {
			restrict: 'EA',
			replace: true,
			templateUrl: 'partials/recipe/hops.html',
			link: function(scope, element, attrs, controller) {

				scope.addHops = function (step) {
					step.hops.push({ amount: 0, aa: 0, type: 'pellet', ibu: 0, mgl: 0, utilisation: 0 });
				};

				scope.removeHops = function (hop, step) {
					var index = step.hops.indexOf(hop.hop);
					if(index > -1) {
						step.hops.splice(index, 1);
					}
				};

				scope.updateHop = function (newHop, hop) {
					hop.name = newHop.name;
					hop.aa = (parseInt(newHop.aahigh)+parseInt(newHop.aalow))/2;
					hop.type = 'pellet';
					hop.href =  newHop.href;
				};
			}
		}
	}).
	directive('autocalcIbu', function (mbIbuCalc, $rootScope) {
		return function(scope, element) {
			var hop = scope.hop;

			function calcIbu() {
				var values = mbIbuCalc.calc({
					amount: hop.amount, 
					aa: hop.aa, 
					boilTime: scope.$parent.step.length, 
					boilGravity: scope.$parent.step.gravity, 
					boilVolume: scope.$parent.step.volume, 
					settings: $rootScope.user.settings
				});
				hop.ibu = Math.round(values.ibu);
				hop.utilisation = values.utilisation.toFixed(2);
				hop.mgl = Math.round(values.mgl, 2);
			};

			// scope.$watch('hop', function () { calcIbu(); console.log('the fucking hop watcher fired')});
			scope.$watch('$parent.step', function () { calcIbu(); console.log('the fucking step watcher fired')}, true);
			
		};
	}).
	service('mbIbuCalc', function () {

		this.calc = function(hopObj) {
			var ibu, mgl, utilisation;

			console.log(hopObj);
			hopObj.boilGravity = hopObj.boilGravity || 1.000;

			console.log(hopObj.boilGravity);

			if(hopObj.settings.formula.bitterness === 'rager') {
				utilisation = mbIbuCalc.ragerUtilisation(hopObj.boilTime);
				mgl = mbIbuCalc.tinsethMgl(hopObj.amount, hopObj.aa, hopObj.boilVolume);
				ibu = this.ragerIbu(hopObj.amount, utilisation, hopObj.aa, hopObj.boilVolume, hopObj.boilGravity);
			}
			else if(hopObj.settings.formula.bitterness === 'tinseth') {
				mgl = this.tinsethMgl(hopObj.amount, hopObj.aa, hopObj.boilVolume);
				utilisation = this.tinsethUtilisation(hopObj.boilGravity, hopObj.boilTime);
				ibu = this.tinsethIbu(utilisation, mgl);
			}

			console.log(ibu + ' ' + utilisation + ' ' + mgl);

			return {
				ibu: ibu,
				utilisation: utilisation,
				mgl: mgl
			}
		};

		// Tinseth
		this.tinsethUtilisation = function (og, boilTime) {
			var boilTimeFactor = (1-Math.exp(-0.04*boilTime))/4.15;
			var bignessFactor = 1.65*Math.pow(0.000125, (og-1));
			var utilisation = bignessFactor * boilTimeFactor;
			return utilisation;
		};
		this.tinsethMgl = function (weight, alphaAcid, batchSize) {
			// mg/L
			alphaAcid = alphaAcid/100;

			return (alphaAcid*weight*1000)/batchSize;
		};

		this.tinsethIbu = function (mgl, utilisation) {
			return utilisation*mgl;
		};

		// Rager
		this.tanh = function (x) {
			var e = Math.exp(2*x);
			return (e-1)/(e+1);
		};

		this.ragerUtilisation = function (boilTime) {
			return (18.11 + 13.86 * this.tanh((boilTime-31.32)/18.27)) / 100;
		};

		this.ragerIbu = function (weight, utilisation, alphaAcid, boilVolume, boilGravity) {
			var ga = 0;
			alphaAcid = alphaAcid/100;
			if(boilGravity > 1.050) {
				ga = (boilGravity-1.050)/0.2;
			}
			return (weight * utilisation * alphaAcid * 1000) / (boilVolume * (1+ga));
		};

		// hop mash adjustment
		this.mashAdjustment = function (aa) {
			return aa*0.2; // 80% decrease in mash
		}
	}).
	controller('HopsCtrl', function ($scope, hops, progressbar, $cacheFactory) {
		var $httpDefaultCache = $cacheFactory.get('$http');
		var cachedData = $httpDefaultCache.get('http://api.microbrew.it/hops');

		console.log($httpDefaultCache);
		progressbar.start();
		hops.getHops().async().then(function(data) {

			$scope.hops = data.hops;
			$scope.orderProp = "name";

			progressbar.complete();
		});
	}).
	controller('HopDetailsCtrl', function ($scope, hops, $routeParams) {
		hops.getHops().async().then(function (data) {
			$scope.hops = data.hops;
			$scope.hop = _(data.hops).reject(function(el) { if(el != null) return el.name != $routeParams.hopid; else return false })[0];

			var substitutions = null;

			if(typeof $scope.hop !== "undefined" && $scope.hop !== null && $scope.hop.substitutions.length > 0) {
				substitutions = [];
				// horrible, please rewrite me
				for(var i=0;i<$scope.hop.substitutions.length;i++) {
					var substituteObj = _(data.hops).reject(function(el) { if(el) return el.href != $scope.hop.substitutions[i]; })[0]
					if(substituteObj) substitutions.push(substituteObj);
				}
			}

			if(substitutions && substitutions.length >0) $scope.substitutions = substitutions;

			console.log(substitutions);
		});
	});