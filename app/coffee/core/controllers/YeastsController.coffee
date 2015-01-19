mbit = angular.module('Microbrewit')

mbit.controller('YeastsController', ['$scope', 'mbGet', '$stateParams', '_'
	($scope, get, $stateParams, _) ->
		console.log 'YeastsController'
		# $scope.loading++

		# We are displaying information about a single hop
		if $stateParams.id
			get.yeasts($stateParams.id).then((apiResponse) ->
				$scope.yeast = apiResponse.yeasts[0]
			)
		# We are displaying all hops
		else
			get.yeasts().then((apiResponse) ->

				$scope.yeasts = _.sortBy(apiResponse.yeasts, (yeast) -> return yeast.Name)
			)
])