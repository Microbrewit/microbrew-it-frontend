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

			.state('hops', {
				abstract: true
				templateUrl: "templates/ingredients/hops.html"
			})
			.state('hops.list', {
				url: '/ingredients/hops'
				controller: 'IngredientController'
				templateUrl: "templates/ingredients/hops.list.html"
			})
			.state('hops.single', {
				url: '/ingredients/hops/{id:[0-9]{1,4}}'
				controller: 'IngredientController'
				templateUrl: "templates/ingredients/hops.single.html"
			})
			.state('fermentables', {
				abstract: true
				templateUrl: "templates/ingredients/fermentables.html"
			})
			.state('fermentables.list', {
				url: '/ingredients/fermentables'
				controller: 'IngredientController'
				templateUrl: "templates/ingredients/fermentables.list.html"
			})
			.state('fermentables.single', {
				url: '/ingredients/fermentables/{id:[0-9]{1,4}}'
				controller: 'IngredientController'
				templateUrl: "templates/ingredients/fermentables.single.html"
			})
			.state('yeasts', {
				abstract: true
				templateUrl: "templates/ingredients/yeast.html"
			})
			.state('yeasts.list', {
				url: '/ingredients/yeasts'
				controller: 'IngredientController'
				templateUrl: "templates/ingredients/yeast.list.html"
			})
			.state('yeasts.single', {
				url: '/ingredients/yeasts/{id:[0-9]{1,4}}'
				controller: 'IngredientController'
				templateUrl: "templates/ingredients/yeast.single.html"
			})

			# Breweries
			.state('breweries', {
				abstract: true
				templateUrl: "templates/brewers/brewers.html"
			})
			.state('breweries.list', {
				url: '/breweries'
				controller: 'BreweriesController'
				templateUrl: "templates/breweries/breweries.list.html"
			})
			.state('breweries.single', {
				url: '/breweries/{id}'
				controller: 'BreweriesController'
				templateUrl: "templates/breweries/breweries.single.html"
			})

			# Brewers (user) states
			.state('brewers', {
				abstract: true
				templateUrl: "templates/brewers/brewers.html"
			})
			.state('brewers.list', {
				url: '/brewers'
				controller: 'BrewerController'
				templateUrl: "templates/brewers/brewers.list.html"
			})
			.state('brewers.single', {
				url: '/brewers/{id}'
				controller: 'BrewerController'
				templateUrl: "templates/brewers/brewers.single.html"
			})

			.state('user', {
				abstract: true
				templateUrl: "templates/brewers/brewers.html"
			})
			.state('user.login', {
				url: '/user/login'
				controller: 'UserController'
				templateUrl: "templates/brewers/user.login.html"
			})
			.state('user.register', {
				url: '/user/register'
				controller: 'UserController'
				templateUrl: "templates/brewers/user.login.html"
			})

			# Beer states
			.state('brews', {
				abstract: true
				templateUrl: "templates/beer/beer.html"
			})
			.state('brews.list', {
				url: '/beers'
				controller: 'BeerController'
				templateUrl: "templates/beer/beer.list.html"
			})
			.state('brews.single', {
				url: '/beers/show/{id:[0-9]{1,5}}'
				controller: 'BeerController'
				templateUrl: "templates/beer/beer.single.html"
			})
			.state('brews.search', {
				url: '/beers/search'
				controller: 'SearchController'
				templateUrl: "templates/search.html"
			})

			# Plain search
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

			
			.state('privacyPolicy', {
				url: "/privacy-policy"
				templateUrl: "templates/company/privacy-policy.html"
			})