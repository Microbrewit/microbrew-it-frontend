mbit = angular.module('Microbrewit')

mbit.controller('HopsController', ['$scope', 'mbGet', '$stateParams', '_'
	($scope, get, $stateParams, _) ->
		console.log 'HopsController'
		# $scope.loading++
		console.log $stateParams
		console.log $scope
		# We are displaying information about a single hop
		if $stateParams.id
			get.hops($stateParams.id).async().then((apiResponse) ->
				# $scope.loading--
				$scope.hop = apiResponse.hops[0]
			)
		# We are displaying all hops
		else
			get.hops().async().then((apiResponse) ->
				console.log apiResponse
				# $scope.loading--
				$scope.hops = _.sortBy(apiResponse.hops, (hop) -> return hop.name)
			)
])