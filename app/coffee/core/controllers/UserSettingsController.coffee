mbit = angular.module('Microbrewit')

mbit.controller('UserSettingsController', ['updateUser', '$scope', '$stateParams', '_'
	(updateUser, $scope, $stateParams, _) ->
		$scope.newSettings = {}

		$scope.$watch('user', (user) ->
			$scope.newSettings = _.clone(user)
		)

		$scope.save = () ->
			updateUser($scope.newSettings).async().then(() -> $scope.user = $scope.newSettings)
			console.log 'save'
		

])