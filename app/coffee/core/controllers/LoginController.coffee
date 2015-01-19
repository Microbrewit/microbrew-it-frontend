mbit = angular.module('Microbrewit')

mbit.controller('LoginController', ['$scope', 'login', '$stateParams', '$state', 'localStorage'
	($scope, login, $stateParams, $state, localStorage) ->
		$scope.username = ""
		$scope.password = ""
		$scope.remember = true

		$scope.login = () ->
			if $scope.username isnt "" and $scope.password isnt ""
				login($scope.username, $scope.password).async().then((user) ->

					# remember login
					if $scope.remember
						localStorage.setItem('user', user)
					
					if $stateParams.redirect
						$state.go($stateParams.redirect)

					else
						$state.go('home')
				)
		
])