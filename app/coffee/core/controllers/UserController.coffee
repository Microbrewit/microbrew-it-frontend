mbit = angular.module('Microbrewit')

mbit.controller('UserController', ['$scope', 'mbGet', '$stateParams', '_'
	($scope, get, $stateParams, _) ->
		# $scope.loading++
		console.log 'HELLO?'
		console.log $stateParams.id
		# We are displaying information about a single user
		if $stateParams.id
			get.user($stateParams.id).async().then((apiResponse) ->
				# $scope.loading--
				$scope.brewer = apiResponse.users[0]
			)

		# User search page
		else
			get.user().async().then((apiResponse) ->
				console.log apiResponse
				# $scope.loading--
				$scope.results = apiResponse #_.sortBy(apiResponse.users, (user) -> return user.username)
			)
])