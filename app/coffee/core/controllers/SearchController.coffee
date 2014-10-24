mbit = angular.module('Microbrewit')

mbit.controller('SearchController', ['$scope', 'mbSearch', '$stateParams',
	($scope, search, $stateParams) ->
		console.log 'CONTROLLER ACTIVE'

		$scope.searchQuery = $stateParams.searchTerm if $stateParams.searchTerm

		$scope.endpoint = "search"

		$scope.endpoints = [
			"search"
			"fermentables"
			"hops"
			"yeasts"
			"recipes"
			"ingredients"
		]

		$scope.$watch('searchQuery', (query = "") ->
			# save used query to scope
			$scope.query = query

			# we only perform an API call if there are more than 3 characters supplied
			if $scope.endpoint is "ingredients"
				endpoint = "search/ingredients"
			else 
				endpoint = $scope.endpoint
			if query? and query.length >= 3
				search(query, endpoint).async().then((apiResponse) ->
					if $scope.endpoint is "search" or $scope.endpoint is "ingredients"
						$scope.results = apiResponse.hits.hits
						console.log apiResponse.hits.hits
					else
						$scope.results = apiResponse[$scope.endpoint]
					$scope.resultsNumber = $scope.results.length
				)
			else
				$scope.results = []
				$scope.resultsNumber = 0
		)    
])