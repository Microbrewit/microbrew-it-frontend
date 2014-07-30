mbit = angular.module('Microbrewit')

mbit.controller('UserSettingsController', ['mbAvailable', '$scope', '$stateParams', '_'
	(mbAvailable, $scope, $stateParams, _) ->
		$scope.newSettings = $scope.user
		$scope.available = mbAvailable
		console.log $scope.user

		# $scope.watch('user', (user) ->
		# 	$scope.newSettings = _.clone(user)
		# )

		$scope.save = () ->
			console.log 'save'
		

])