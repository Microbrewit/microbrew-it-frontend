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

		$rootScope.user = {
			settings: mbUser.standardSettings
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
	controller('RecipeCtrl', function ($scope, hops, fermentables, yeasts, progressbar, mbUser) {
		$scope.settings = $scope.user.settings;
		// get ingredients
		progressbar.start();
		var returned = 0;
		var requests = 0;

		$scope.$watch('recipe', function () {
			console.log('scope updated');
		});

		function callbacks() {
			returned++;
			console.log('callback ' + returned+ '/' + requests);
			if(returned == requests) {
				progressbar.complete();
			}
		}

		function updateStepNumbers() {
			for(var i = 0;i<$scope.recipe.mashSteps.length;i++) {
				$scope.recipe.mashSteps[i].number = i+1;
			}
			for(var i=0;i<$scope.recipe.boilSteps.length;i++) {
				$scope.recipe.boilSteps[i].number = $scope.recipe.mashSteps.length+i+1;
			}
			for(var i=0;i<$scope.recipe.fermentationSteps.length;i++) {
				$scope.recipe.fermentationSteps[i].number = $scope.recipe.mashSteps.length+$scope.recipe.boilSteps.length+i+1;
			}
		}

		// add steps
		$scope.addMashStep = function () {
			console.log('Add mash step');
			$scope.recipe.mashSteps.push({
			});
			updateStepNumbers();
		}
		$scope.addBoilStep = function () {
			console.log('Add boil step');
			$scope.recipe.boilSteps.push({});
			updateStepNumbers();
		}
		$scope.addFermentationStep = function () {
			console.log('Add fermentation step');
			$scope.recipe.fermentationSteps.push({});
			updateStepNumbers();
		}

		requests++;
		hops.getHops().async().then(function(data) {
			$scope.hopsDb = data.hops;
			$scope.hopsDb.orderProp = "name";

			callbacks();
		});

		requests++;
		fermentables.getFromAPI().async().then(function(data) {
			$scope.fermentablesDb = data.fermentables;
			// $scope.fermentables.orderProp = "name";

			callbacks();
		});

		requests++;
		yeasts.getYeasts().async().then(function(data) {
			$scope.yeastsDb = data.yeasts;
			// $scope.yeasts.orderProp = "name";

			callbacks();
		});

		$scope.recipe = {};

		// need to implement users properly
		if(false) {	
			$scope.recipe.brewer = {
				brewer: [{
					id: $scope.user.id,
					href: $scope.user.href
				}]
			}; // instantiate recipe
		}

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
						amount: 20,
						colourContribution: 0
					}
				],
				hops: [],
				spices: [],
				fruits: [],
				notes: ""
			}
		];

		$scope.recipe.boilSteps = [
			{
				number: $scope.recipe.mashSteps.length+1,
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
				fermentables: [],
				notes: ''
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