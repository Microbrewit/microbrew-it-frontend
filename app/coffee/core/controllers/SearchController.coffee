mbit = angular.module('Microbrewit')

mbit.controller('SearchController', ['$scope', 'mbSearch', '$stateParams', '$state', '$rootScope',
	($scope, search, $stateParams, $state, $rootScope) ->
		console.log 'CONTROLLER ACTIVE'

		$scope.searchQuery = $state.params.searchTerm if $state.params.searchTerm
		$rootScope.showNav = true

		$scope.endpoints = [
			"search"
			"fermentables"
			"hops"
			"yeasts"
			"recipes"
			"ingredients"
			"beers"
		]

		# Set endpoint
		switch $state.current.name
			when "breweries.search" then $scope.endpoint = "breweries"
			when "brewers.search" then $scope.endpoint = "users"
			when "ingredients.search" then $scope.endpoint = "ingredients"
			when "brews.search" then $scope.endpoint = "beers"
			when "yeasts.search" then $scope.endpoint = "yeasts"
			when "hops.search" then $scope.endpoint = "hops"
			when "fermentables.search" then $scope.endpoint = "fermentables"
			else $scope.endpoint = "search"

		$rootScope.title = $scope.endpoint

		$scope.$watch('searchQuery', (query = "") ->
			# save used query to scope
			$scope.query = query

			# we only perform an API call if there are more than 3 characters supplied
			if $scope.endpoint is "ingredients"
				endpoint = "search/ingredients"
			else 
				endpoint = $scope.endpoint
				
			if query?.length >= 3
				search(query, endpoint).then((apiResponse) ->
					if $scope.endpoint is "search" or $scope.endpoint is "ingredients"

						parsed = []

						for result in apiResponse.hits.hits
							res = result._source
							res._source = result._source
							parsed.push res

						$scope.results = parsed
						
					else
						$scope.results = apiResponse[$scope.endpoint]
					$scope.resultsNumber = $scope.results.length
				)
			else
				$scope.results = []
				$scope.resultsNumber = 0
		)    
])