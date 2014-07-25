mbit = angular.module('Microbrewit')

mbit.controller('SearchController', ['$scope', 'search', 
	($scope, search) ->
		console.log 'CONTROLLER ACTIVE'

		$scope.endpoint = "hops"

		$scope.endpoints = [
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
					$scope.results = apiResponse[$scope.endpoint]
					$scope.resultsNumber = $scope.results.length
				)
			else
				$scope.results = []
				$scope.resultsNumber = 0
		)    
])