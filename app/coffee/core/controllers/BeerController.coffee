mbit = angular.module('Microbrewit')

mbit.controller('BeerController', [
	'$rootScope'
	'$scope'
	'$state'
	'_'
	'mbBeer'
	($rootScope, $scope, $state, _, mbBeer) ->
		$scope.bubble = 19

		# Set the state of the controller
		# BeerController is used as a main controller for all beer-related things
		setControllerState = (event, toState, toParams, fromState, fromParams) ->
			console.log 'BeerController.setControllerState' 
			$scope.bubble = 19
			# Clean up scope state
			$scope.isUserRecipe = false
			$scope.showNav = true
			$scope.fork = null
			$scope.beerToFork = null

			$scope.headers =
				title: 'Beer'
				subheader: false

			currentState = toState?.name 
			currentState ?= $state?.current?.name

			# We are displaying information about a single beer
			if currentState is 'brews.single'
				beerId = toParams?.id
				beerId ?= $state.params.id

				mbBeer.get({id: beerId}).then((apiResponse) ->

					$scope.beer = apiResponse[0]
					$scope.bubble = $scope.beer.srm.standard or= 19
					if $scope.user 
						for user in $scope.beer.brewers
							$scope.isUserRecipe = true  if user.username is $scope.user.username

					$scope.headers =
						title: $scope.beer.name
						subheader: $scope.beer.beerStyle.name

					$scope.recipe = $scope.beer.recipe

					if $scope.recipe.mashSteps[0].number is 0
						$scope.recipe.mashSteps[0].number = 1

				)
				$rootScope.beerToFork = $scope.beer
				$rootScope.fork = () ->
					$state.go('brews.fork', { "fork": $stateParams.id })
				$scope.forks = []

			# We are on the beer listing/discovery page
			else if currentState is 'brews.list'
				mbBeer.get({latest:true}).then((apiResponse) ->
					$scope.results = apiResponse
				)

			else if currentState is 'account.beers'
				$scope.results = $scope.user.beers
				
			else if currentState is 'brews.search'
				query = toParams?.query
				query ?= $state.params.query


				mbBeer.get({query: query}, 'beers').then((apiResponse) ->
					$scope.results = apiResponse
					$scope.resultsNumber = apiResponse.length
				)

		setControllerState()
		$scope.$on('$stateChangeStart', setControllerState)
		
		$scope.search = (query) ->
			$state.go('brews.search', {query:query})

		$scope.delete = (id) ->
			mbBeer.delete(id).then(() -> $state.go('brews.list'))
])