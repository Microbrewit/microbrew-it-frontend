mbit = angular.module('Microbrewit')

mbit.controller('YeastsController', ['$scope', 'mbGet','mbPut','mbDelete', '$stateParams', '_'
	($scope, get, put, mbDelete, $stateParams, _) ->
		console.log 'YeastsController'
		console.log $scope
		console.log $stateParams
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

		$scope.updateYeast = () ->
			console.log 'update yeast'
			put.yeasts($scope.yeast).async().then()

		$scope.deleteYeast = () ->
			console.log 'delete yeast'
			mbDelete.yeasts($scope.yeast).async().then()

])