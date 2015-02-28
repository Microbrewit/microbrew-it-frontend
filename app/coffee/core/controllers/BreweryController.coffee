mbit = angular.module('Microbrewit')

mbit.controller('BreweryController', ['$rootScope', '$scope', '$state', 'mbGet', '$stateParams', '_'
	($rootScope, $scope, $state, get, $stateParams, _) ->

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
					{title:'Search', sref:'breweries.search'}
				]
			
			# We are displaying information about a single user
			if currentState is 'breweries.single'
				breweryId = toParams?.id
				breweryId ?= $state.params.id
				get.brewery(breweryId).then((apiResponse) ->
					# $scope.loading--
					$scope.addBeer = () ->
						console.log 'ADD BEER'
						$rootScope.brewery = _.cloneDeep $scope.brewery
						$state.go('add')
					$scope.brewery = apiResponse.breweries[0]
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
				
				get.brewery().then((apiResponse) ->
					$scope.breweries = apiResponse.breweries
				)

			else if currentState is 'account.breweries'
				$scope.breweries = $scope.user.breweries

		setControllerState()
		$rootScope.$on('$stateChangeStart', setControllerState)
])