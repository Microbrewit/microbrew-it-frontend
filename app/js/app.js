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
      .when('/', {templateUrl: 'partials/index.html', controller: 'BreweryCtrl'});
      // $routeProvider.otherwise({redirectTo: '/index'});
  	}]);
// app.get('/user/:userName', routes.user);
// app.get('/add/user', routes.addUser);
// app.get('/login', routes.loginCheck);

// searches
// app.get('/find/:searchTerms', routes.find);
// app.get('/find/user/:name', routes.findUser);
// app.get('/find/brewery/:name', routes.findBrewery);
// app.get('/find/beer/:name', routes.findBeer);

// beer and breweries
// app.get('/brewery/:brewery/:id', routes.brewery);
// app.get('/brewery/:id', routes.brewery);
// app.get('/brewery/:brewery/:id/:beer', routes.beer);

// add new beers and breweries
// app.get('/add/brewery', routes.addBrewery);
// app.get('/add/beer', routes.addBeer);