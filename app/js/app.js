'use strict';


// Declare app level module which depends on filters, and services
angular.module('microbrewit', ['microbrewit.filters', 'microbrewit.services', 'microbrewit.directives', 'microbrewit.controllers']).
  	config(['$routeProvider', function($routeProvider) {
      $routeProvider.when('/beer', {templateUrl: 'partials/beer.html', controller: 'BeerCtrl'})
      .when('/brewery', {templateUrl: 'partials/brewery.html', controller: 'BreweryCtrl'})
      .when('/add', {templateUrl: 'partials/add.html', controller: 'RecipeCtrl'})
      .when('/search', {templateUrl: 'partials/search.html', controller: 'BreweryCtrl'})
      .when('/login', {templateUrl: 'partials/login.html', controller: 'BreweryCtrl'})
      .when('/register', {templateUrl: 'partials/register.html', controller: 'BreweryCtrl'})
      .when('/profile', {templateUrl: 'partials/profile.html', controller: 'ProfileCtrl'})
      .when('/calculators', {templateUrl: 'partials/calculators.html', controller: 'CalculatorCtrl'})
      .when('/calculators/abv', {templateUrl: 'partials/calculators/abv.html', controller: 'CalculatorCtrl'})
      .when('/company/privacy-policy', {templateUrl: 'partials/company/privacy-policy.html', controller: 'CalculatorCtrl'})
      .when('/more', {templateUrl: 'partials/more.html'})
      .when('/', {templateUrl: 'partials/index.html'});
      $routeProvider.otherwise({templateUrl: 'partials/404.html'});
  	}]);