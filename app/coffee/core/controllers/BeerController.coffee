mbit = angular.module('Microbrewit')

mbit.controller('BeerController', ['$rootScope', '$scope', '$state', 'mbGet', '$stateParams', '_'
	($rootScope, $scope, $state, get, $stateParams, _) ->

		# We are displaying information about a single beer
		if $stateParams.id
			get.beers({id: $stateParams.id}).async().then((apiResponse) ->
				$scope.beer = apiResponse.beers[0]
			)
			$scope.fork = () ->
				$rootScope.beerToFork = $scope.beer
				$state.go('fork', { "fork": $stateParams.id })
			$scope.forks = []

		# We are on the beer listing/discovery page
		else
			get.beers({latest:true}).async().then((apiResponse) ->
				$scope.brews = apiResponse
			)
])