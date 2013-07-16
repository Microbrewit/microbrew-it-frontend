'use strict';


// Declare app level module which depends on filters, and services
angular.module('microbrewit', ['microbrewit.filters', 'microbrewit.services', 'microbrewit.directives', 'microbrewit.controllers', 'angular-underscore', 'ngCookies']).
    run(function($rootScope, user) {

      // check if user is logged in
      $rootScope.isLogged = user.isLogged();

      if($rootScope.isLogged) {
        $rootScope.profile = user.getDetails();
      }

    }).
  	config(['$routeProvider', function($routeProvider, $rootScope) {
      $routeProvider.when('/beer', {templateUrl: 'partials/beer.html', controller: 'BeerCtrl'})
      .when('/brewery', {templateUrl: 'partials/brewery.html', controller: 'BreweryCtrl'})
      .when('/add', {templateUrl: 'partials/add.html', controller: 'RecipeCtrl'})
      .when('/search', {templateUrl: 'partials/search.html', controller: 'BreweryCtrl'})
      .when('/calculators', {templateUrl: 'partials/calculators.html', controller: 'CalculatorCtrl'})
      .when('/calculators/abv', {templateUrl: 'partials/calculators/abv.html', controller: 'CalculatorCtrl'})
      .when('/calculators/srm', {templateUrl: 'partials/calculators/srm.html', controller: 'SrmCtrl'})
      .when('/company/privacy-policy', {templateUrl: 'partials/company/privacy-policy.html', controller: 'CalculatorCtrl'})
      .when('/more', {templateUrl: 'partials/more.html'});


        $routeProvider.when('/', {templateUrl: 'partials/index.html'})
        .when('/login', {templateUrl: 'partials/login.html', controller: 'LoginCtrl'})
        .when('/register', {templateUrl: 'partials/register.html', controller: 'BreweryCtrl'});
      

      $routeProvider.otherwise({templateUrl: 'partials/404.html'});
  	}]);