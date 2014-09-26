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
		]

		$scope.$watch('searchQuery', (query = "") ->
			# save used query to scope
			$scope.query = query

			# we only perform an API call if there are more than 3 characters supplied
			if query? and query.length >= 3
				search(query, $scope.endpoint).async().then((apiResponse) ->
					if $scope.endpoint is "search"
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