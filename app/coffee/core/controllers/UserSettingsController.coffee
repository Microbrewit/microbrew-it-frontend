mbit = angular.module('Microbrewit')

mbit.controller('UserSettingsController', ['mbAvailable', 'updateUser', '$scope', '$stateParams', '_'
	(mbAvailable, updateUser, $scope, $stateParams, _) ->
		$scope.newSettings = {}
		$scope.available = mbAvailable

		$scope.$watch('user', (user) ->
			$scope.newSettings = _.clone(user)
		)

		$scope.save = () ->
			updateUser($scope.newSettings).async().then(() -> $scope.user = $scope.newSettings)
			console.log 'save'
		

])