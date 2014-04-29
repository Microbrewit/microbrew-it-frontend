# Configure Microbrew.it application (import modules + configure router)
# @author Torstein Thune
# @copyright 2014 Microbrew.it

mbit = angular.module('Microbrewit', ['ui.router'])

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
			url: "/login"
			templateUrl: "templates/login.html"
		})
		.state('breweries', {
			url: "/login"
			templateUrl: "templates/login.html"
		})
		.state('brewers', {
			url: "/login"
			templateUrl: "templates/login.html"
		})
		.state('more', {
			url: "/login"
			templateUrl: "templates/login.html"
		})
    	.state('add', {
			url: "/login"
			templateUrl: "templates/login.html"
		})