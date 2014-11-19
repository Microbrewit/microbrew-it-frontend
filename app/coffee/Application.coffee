# Configure Microbrew.it application (import modules + configure router)
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit', 
	[
		'ui.router' # External
		'angular-loading-bar' # External
		'Microbrewit/core/Calculation'
		'Microbrewit/core/Network'
		'Microbrewit/core/Notifications'
		'Microbrewit/core/User'
		'Microbrewit/core/Utils'
	]
)
	.config ($httpProvider, $stateProvider, $urlRouterProvider) ->
		# Enable CORS
		$httpProvider.defaults.useXDomain = true

		# For any unmatched url, redirect to /state1
		$urlRouterProvider
			.when('fermentabledto/:id', 'fermentables/:id')
			.when('yeastdto/:id', 'yeasts/:id')
			.when('hopdto/:id', 'hops/:id')
			.otherwise("/")

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
			.state('yeasts', {
				abstract: true
				templateUrl: "templates/ingredients/yeast.html"
			})
			.state('yeasts.list', {
				url: '/yeasts'
				controller: 'YeastsController'
				templateUrl: "templates/ingredients/yeast.list.html"
			})
			.state('yeasts.single', {
				url: '/yeasts/{id:[0-9]{1,4}}'
				controller: 'YeastsController'
				templateUrl: "templates/ingredients/yeast.single.html"
			})
			.state('breweries', {
				url: "/breweries"
				templateUrl: "templates/login.html"
			})
			.state('brewers', {
				abstract: true
				templateUrl: "templates/brewers/brewers.html"
			})
			.state('brewers.list', {
				url: '/brewers'
				controller: 'UserController'
				templateUrl: "templates/brewers/brewers.list.html"
			})
			.state('brewers.single', {
				url: '/brewers/{id}'
				controller: 'UserController'
				templateUrl: "templates/brewers/brewers.single.html"
			})
			.state('brews', {
				abstract: true
				templateUrl: "templates/brews/brews.html"
			})
			.state('brews.list', {
				url: '/brews'
				controller: 'BeerController'
				templateUrl: "templates/brews/brews.list.html"
			})
			.state('brews.single', {
				url: '/brews/{id:[0-9]{1,5}}'
				controller: 'BeerController'
				templateUrl: "templates/brews/brews.single.html"
			})
			.state('search', {
				url: "/search"
				templateUrl: "templates/search.html"
				controller: "SearchController"
			})
			.state('searchWithTerm', {
				url: "/search/:searchTerm"
				templateUrl: "templates/search.html"
				controller: "SearchController"
			})
			.state('add', {
				url: "/add"
				templateUrl: "templates/recipe/add.html"
				controller: "RecipeController"
			})
			.state('fork', {
				url: "/brews/:fork/fork"
				templateUrl: "templates/recipe/add.html"
				controller: "RecipeController"
			})
			.state('add.beer', {
				url: "/beer"
			})
			.state('add.brewery', {
				url: "/brewery"
			})
			.state('add.ingredient', {
				url: "/ingredient"
			})
			.state('abv-calculator', {
				url: "/calculators/abv"
				templateUrl: "templates/calculators/abv.html"
				controller: "CalculatorController"
			})
			.state('login', {
				url: "/login"
				templateUrl: "templates/users/login.html"
				controller: "LoginController"
			})
			.state('userSettings', {
				url: "/user/settings"
				templateUrl: "templates/users/settings.html"
				controller: "UserSettingsController"
			})
			.state('privacyPolicy', {
				url: "/privacy-policy"
				templateUrl: "templates/company/privacy-policy.html"
			})