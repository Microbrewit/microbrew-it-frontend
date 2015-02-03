mbit = angular.module('Microbrewit')

mbit.controller('UserController', ['$scope', 'login', 'mbGet', '$stateParams', '$state', 'localStorage', '$rootScope',
	($scope, login, mbGet, $stateParams, $state, localStorage, $rootScope) ->

		$scope.username = ""
		$scope.password = ""
		$scope.remember = true

		# We are in login state
		if $state.current.name is 'user.login'

			$rootScope.title = 'Login'
			$rootScope.bubble = ''

			# Login
			$scope.login = () ->
				if $scope.username isnt "" and $scope.password isnt ""
					login($scope.username, $scope.password).async().then((userId) ->

						mbGet.user(userId).then((response) ->
							user = response.users[0]
							$rootScope.user = user
							
							if $scope.remember
								localStorage.setItem('user', user)
							
							if $stateParams.redirect
								$state.go($stateParams.redirect)

							else
								$state.go('home')
							
						)
					)

		# We are in register state
		else if $state.current.name is 'user.register'
			$scope.register = () ->
				$rootScope.title = 'Register'
				$rootScope.bubble = ''

		
])