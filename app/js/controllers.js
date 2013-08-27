'use strict';

/* Controllers */


angular.module('microbrewit.controllers', []).
	controller('MainCtrl', function ($scope, mbUser, breadcrumbs, $location, progressbar, $rootScope, $cookies, $cookieStore) {
		$scope.title = "Microbrew.it";
		$scope.breadcrumbs = breadcrumbs;

		// check user cookie
		if(mbUser.isLogged()) {
			mbUser.setupUserSession(mbUser.getDetailsFromCookie());
		}

		console.log($cookieStore.get('mb_auth'));



		$scope.close = function () {
			progressbar.close();
		}

		$rootScope.$watch('user', function (user) {
			console.log('mainCtrl detected user change: ');
			console.log($rootScope.user);
			$scope.user = $rootScope.user;
		});

		if($location.url != "/") {
			$scope.location = true;
		} else {
			$scope.location = false;
		}
		// mbUser.destroyUserSession();
	}).
	controller('RecipeCtrl', function ($scope, hops, fermentables, yeasts, progressbar) {

		console.log('yo!');

		// get ingredients
		progressbar.start();
		var returned = 0;
		var requests = 0;

		function callbacks() {
			returned++;
			console.log('callback ' + returned+ '/' + requests);
			if(returned == requests) {
				progressbar.complete();
			}
		}

		requests++;
		hops.getHops().async().then(function(data) {
			$scope.hops = data.hops;
			$scope.hops.orderProp = "name";

			callbacks();
		});

		requests++;
		fermentables.getFermentables().async().then(function(data) {
			$scope.fermentables = data.fermentables;
			$scope.fermentables.orderProp = "name";

			callbacks();
		});

		requests++;
		yeasts.getYeasts().async().then(function(data) {
			$scope.yeasts = data.yeasts;
			$scope.yeasts.orderProp = "name";

			callbacks();
		});

		$scope.recipe = {};

		$scope.recipe.mashSteps = [
			{
				number: 1,
				type: "infusion",
				length: 60,
				volume: 20,
				temperature: 65,
				fermentables: [
					{
						id: "1377073452234",
						href: "http://microbrew.it/ontology.owl#Boortmalt_Amber_Malt",
						name: "Amber Malt",
						colour: "20",
						ppg: "34",
						suppliedbyid: "http://microbrew.it/ontology.owl#Boortmalt",
						origin: 'Germany',
						suppliedBy: 'Boortmalt',
						amount: 20
					}
				],
				hops: [
					{

					}],
				spices: [],
				fruits: [],
				notes: ""
			}
		];

		$scope.recipe.boilSteps = [
			{
				number: 2,
				length: 60,
				volume: 20,
				fermentables: [],
				hops: [],
				spices: [],
				fruits: [],
				notes: ""
			}
		];

		$scope.recipe.fermentationSteps = [
			{
				number: 3,
				type: 'primary fermentation',
				length: 14,
				temperature: 24,
				fermentables: [],
				hops: [],
				spices: [],
				fruits: [],
				yeast: [],
				notes: ""
			}
		];

		$scope.recipe.bottling = [
			{
				fermentables: []
			}
		];

		$scope.recipe.notes = "";

	}).
	controller('CalculatorCtrl', function($scope) {
		$scope.abvCalc = {
			og: 1.050,
			fg: 1.010
		};
  });