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
	service('mbIbuCalc', function () {
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
	}).
	controller('HopsCtrl', function ($scope, hops, progressbar) {
		progressbar.start();

		hops.getHops().async().then(function(data) {

			$scope.hops = data.hops;
			$scope.orderProp = "name";

			progressbar.message('Hello world', '#DE5C5C');
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