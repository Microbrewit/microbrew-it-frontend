mbit = angular.module('Microbrewit')

mbit.controller('LoginController', ['$scope', 'login', '$stateParams', '$state', 'localStorage'
	($scope, login, $stateParams, $state, localStorage) ->
		$scope.username = "torstein"
		$scope.password = "test"
		$scope.remember = false

		$scope.login = () ->
			if $scope.username isnt "" and $scope.password isnt ""
				login($scope.username, $scope.password).async().then((response) ->

					# remember login
					if $scope.remember
						localStorage.setItem('user', $scope.user)
					
					if $stateParams.redirect
						$state.go($stateParams.redirect)
					else
						$state.go('home')
				)
		
])