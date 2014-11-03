mbit = angular.module('Microbrewit')

mbit.controller('BeerController', ['$rootScope', '$scope', '$state', 'mbGet', '$stateParams', '_'
	($rootScope, $scope, $state, get, $stateParams, _) ->
		console.log 'BeerController'
		# $scope.loading++
		console.log $stateParams

		# We are displaying information about a single beer
		if $stateParams.id
			console.log "We have this id: #{$stateParams.id}"
			get.beers({id: $stateParams.id}).async().then((apiResponse) ->
				# $scope.loading--
				console.log apiResponse.beers[0]
				$scope.beer = apiResponse.beers[0]
			)
			$scope.fork = () ->
				$rootScope.beerToFork = $scope.beer
				$state.go('fork', { "fork": $stateParams.id })
			$scope.forks = []
		# We are displaying all hops
		else
			get.beers({latest:true}).async().then((apiResponse) ->
				console.log 'WE HAVE HAD A RESPONSE'
				console.log apiResponse
				# $scope.loading--
				$scope.brews = apiResponse
			)
])