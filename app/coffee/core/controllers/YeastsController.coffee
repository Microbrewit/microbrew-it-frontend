mbit = angular.module('Microbrewit')

mbit.controller('YeastsController', ['$scope', 'get', '$stateParams', '_'
	($scope, get, $stateParams, _) ->
		console.log 'YeastsController'
		# $scope.loading++

		# We are displaying information about a single hop
		if $stateParams.id
			get.yeasts($stateParams.id).async().then((apiResponse) ->
				# $scope.loading--
				$scope.yeast = apiResponse.yeasts[0]
			)
		# We are displaying all hops
		else
			get.yeasts().async().then((apiResponse) ->
				console.log apiResponse
				# $scope.loading--
				$scope.yeasts = _.sortBy(apiResponse.yeasts, (yeast) -> return yeast.Name)
			)
])