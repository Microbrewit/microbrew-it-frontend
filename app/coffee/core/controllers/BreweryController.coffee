mbit = angular.module('Microbrewit')

mbit.controller('BreweryController', ['$rootScope', '$scope', '$state', 'mbBrewery', '$stateParams', '_'
	($rootScope, $scope, $state, mbBrewery, $stateParams, _) ->

				# Set the state of the controller
		# BeerController is used as a main controller for all beer-related things
		setControllerState = (event, toState, toParams, fromState, fromParams) ->
			currentState = toState?.name 
			currentState ?= $state?.current?.name

			$scope.header =
				bubble: ""
				title: "breweries"
				subHeader: ""
				description: ""
				navigation: [
					{title:'Latest', sref:'breweries.list'}
				]
			
			# We are displaying information about a single user
			if currentState is 'breweries.single'
				breweryId = toParams?.id
				breweryId ?= $state.params.id
				mbBrewery.get(breweryId).then((apiResponse) ->
					# $scope.loading--
					$scope.addBeer = () ->
						console.log 'ADD BEER'
						$rootScope.brewery = _.cloneDeep $scope.brewery
						$state.go('add')
					$scope.brewery = apiResponse[0]
					subHeader = $scope.brewery.type
					subHeader += " since #{$scope.brewery.established}" if $scope.brewery.established?
					$scope.header = 
						title: $scope.brewery.name
						bubble: ''
						subHeader: subHeader
						description: $scope.brewery.description
						navigation: false
				)

			# User search page
			else if currentState is 'breweries.list'
				
				mbBrewery.get().then((apiResponse) ->
					$scope.results = apiResponse
				)

			else if currentState is 'account.breweries'
				$scope.results = $scope.user.breweries

			else if currentState is 'breweries.search'
				query = toParams?.query
				query ?= $state.params.query


				mbBrewery.get({query: query}, 'breweries').then((apiResponse) ->
					$scope.results = apiResponse
					$scope.resultsNumber = apiResponse.length
				)

		setControllerState()
		$scope.$on('$stateChangeStart', setControllerState)

		$scope.search = (query) ->
			$state.go('breweries.search', {query:query})
])