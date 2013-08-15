'use strict';


// Declare app level module which depends on filters, and services
angular.module('microbrewit', ['ngResource', 'microbrewit.filters', 'microbrewit.services', 'microbrewit.directives', 'microbrewit.controllers', 'angular-underscore', 'ngCookies', 'services.breadcrumbs']).
  run(function($rootScope, mbUser) {

  }).
  config(['$routeProvider', function($routeProvider, $rootScope) {
    $routeProvider.when('/add', {templateUrl: 'partials/add.html', controller: 'RecipeCtrl'})
      
      .when('/search', {templateUrl: 'partials/search.html', controller: 'BreweryCtrl'})
      
      .when('/company/privacy-policy', {templateUrl: 'partials/company/privacy-policy.html'})
      .when('/company/terms-of-service', {templateUrl: 'partials/company/terms-of-service.html'})
      .when('/more', {templateUrl: 'partials/more.html'})

      .when('/calculators', {templateUrl: 'partials/calculators.html', controller: 'CalculatorCtrl'})
      .when('/calculators/abv', {templateUrl: 'partials/calculators/abv.html', controller: 'CalculatorCtrl'})
      .when('/calculators/colour', {templateUrl: 'partials/calculators/colour.html'})
      .when('/calculators/bitterness', {templateUrl: 'partials/calculators/bitterness.html'})

      .when('/hops', {templateUrl: 'partials/hops.html', controller: 'HopsCtrl'})
      .when('/hops/:hopid', {templateUrl: 'partials/hopDetails.html', controller: 'HopDetailsCtrl'})

      .when('/breweries', {templateUrl: 'partials/breweries.html', controller: 'BreweryCtrl'})
      .when('/breweries/:brewery', {templateUrl: 'partials/brewery.html', controller: 'BreweryCtrl'})

      .when('/beers', {templateUrl: 'partials/singleBeer.html', controller: 'BeerCtrl'})
      .when('/beers/:beer', {templateUrl: 'partials/beer.html', controller: 'BeerCtrl'})


      .when('/profile', {templateUrl: 'partials/profile.html'})

      .when('/', {templateUrl: 'partials/index.html'})

      .when('/login', {templateUrl: 'partials/login.html', controller: 'LoginCtrl'})
      .when('/register', {templateUrl: 'partials/register.html', controller: 'BreweryCtrl'});



    $routeProvider.otherwise({templateUrl: 'partials/404.html'});
  }]);