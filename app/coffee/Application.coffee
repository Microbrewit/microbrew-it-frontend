# Configure Microbrew.it application (import modules + configure router)
# @author Torstein Thune
# @copyright 2014 Microbrew.it

mbit = angular.module('Microbrewit', ['ui.router', 'Microbrewit/core/network/NetworkService', 'Microbrewit/core/utils/Lodash'])

mbit.config ($stateProvider, $urlRouterProvider) ->
	# For any unmatched url, redirect to /state1
	$urlRouterProvider.otherwise("/")

	# Now set up the states
	$stateProvider
		.state('home', {
			url: "/"
			templateUrl: "templates/home.html"
		})
		.state('beer', {
			url: "/beer"
			templateUrl: "templates/login.html"
		})
		.state('hops', {
			abstract: true
			templateUrl: "templates/ingredients/hops.html"
		})
		.state('hops.list', {
			url: '/hops'
			controller: 'HopsController'
			templateUrl: "templates/ingredients/hops.list.html"
		})
		.state('hops.single', {
			url: '/hops/{id:[0-9]{1,4}}'
			controller: 'HopsController'
			templateUrl: "templates/ingredients/hops.single.html"
		})
		.state('fermentables', {
			abstract: true
			templateUrl: "templates/ingredients/fermentables.html"
		})
		.state('fermentables.list', {
			url: '/fermentables'
			controller: 'FermentablesController'
			templateUrl: "templates/ingredients/fermentables.list.html"
		})
		.state('fermentables.single', {
			url: '/fermentables/{id:[0-9]{1,4}}'
			controller: 'FermentablesController'
			templateUrl: "templates/ingredients/fermentables.single.html"
		})
		.state('breweries', {
			url: "/breweries"
			templateUrl: "templates/login.html"
		})
		.state('brewers', {
			url: "/brewers"
			templateUrl: "templates/login.html"
		})
		.state('search', {
			url: "/search"
			templateUrl: "templates/search.html"
			controller: "SearchController"
		})
    	.state('add', {
			url: "beer/add"
			templateUrl: "templates/beer/add.html"
		})