# Configure Microbrew.it application (import modules + configure router)
# @author Torstein Thune
# @copyright 2014 Microbrew.it

mbit = angular.module('Microbrewit', ['ui.router', 'Microbrewit/core/network/NetworkService'])

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