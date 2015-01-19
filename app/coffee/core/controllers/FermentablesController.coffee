mbit = angular.module('Microbrewit')

mbit.controller('FermentablesController', ['$scope', 'mbGet', '$stateParams', '_'
	($scope, get, $stateParams, _) ->
		console.log 'FermentablesController'
		# $scope.loading++
		console.log $stateParams
		console.log $scope
		# We are displaying information about a single hop
		if $stateParams.id
			get.fermentables($stateParams.id).then((apiResponse) ->
				# $scope.loading--
				console.log apiResponse.fermentables[0]
				$scope.fermentable = apiResponse.fermentables[0]
			)
		# We are displaying all hops
		else
			get.fermentables().then((apiResponse) ->
				console.log apiResponse
				# $scope.loading--
				$scope.fermentables = _.sortBy(apiResponse.fermentables, (fermentable) -> return fermentable.name)
			)
])