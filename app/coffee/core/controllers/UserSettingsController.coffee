mbit = angular.module('Microbrewit')

mbit.controller('UserSettingsController', ['updateUser', '$scope', '$stateParams', '_', 'localStorage',
	(updateUser, $scope, $stateParams, _, localStorage) ->
		$scope.newSettings = {}

		$scope.$watch('user', (user) ->
			$scope.newSettings = _.clone(user)
		)

		$scope.invalidateCache = () ->
			localStorage.removeItem('fermentables')
			localStorage.removeItem('hops')
			localStorage.removeItem('yeasts')
			localStorage.removeItem('hopForms')
			localStorage.removeItem('beerstyles')

		$scope.logout = () ->
			localStorage.removeItem('user')
			localStorage.removeItem('token')

		$scope.save = () ->
			updateUser($scope.newSettings).async().then(() -> $scope.user = $scope.newSettings)
			console.log 'save'
		

])