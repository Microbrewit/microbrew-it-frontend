mbit = angular.module('Microbrewit')

mbit.controller('BreweryController', ['$rootScope', '$scope', '$state', 'mbGet', '$stateParams', '_'
	($rootScope, $scope, $state, get, $stateParams, _) ->

		# We are displaying information about a single beer
		if $stateParams.id
			get.breweries({id: $stateParams.id}).then((apiResponse) ->
				$scope.brewery = apiResponse.beers[0]
				$rootScope.title = $scope.brewery.name
			)

		# We are on the beer listing/discovery page
		else
			$rootScope.title = "Beers"
			get.breweries({latest:true}).then((apiResponse) ->
				$scope.breweries = apiResponse
			)
])