mbit = angular.module('Microbrewit')

mbit.controller('FermentablesController', ['$scope', 'get', '$stateParams', '_'
	($scope, get, $stateParams, _) ->
		console.log 'FermentablesController'
		# $scope.loading++
		console.log $stateParams
		console.log $scope
		# We are displaying information about a single hop
		if $stateParams.id
			get.fermentables($stateParams.id).async().then((apiResponse) ->
				# $scope.loading--
				$scope.fermentable = apiResponse.fermentables[0]
			)
		# We are displaying all hops
		else
			get.fermentables().async().then((apiResponse) ->
				console.log apiResponse
				# $scope.loading--
				$scope.fermentables = _.sortBy(apiResponse.fermentables, (fermentable) -> return fermentable.name)
			)
])