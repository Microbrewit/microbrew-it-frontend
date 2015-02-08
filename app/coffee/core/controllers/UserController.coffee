# Controller for user
#
# In charge of register and login
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit').controller('UserController', [
	'$scope'
	'mbUser'
	'$state'
	'localStorage'
	'$rootScope'
	($scope, mbUser, $state, localStorage, $rootScope) ->

		
		$scope.remember = true

		# We are in login state
		if $state.current.name is 'user.login'

			$rootScope.title = 'Login'
			$rootScope.bubble = ''

		# We are in register state
		else if $state.current.name is 'user.register'
			$scope.register = () ->
				$scope.title = 'Register'
				$scope.bubble = ''

		# Login
		$scope.login = () ->

			mbUser.login($scope.username, $scope.password).then((userId) ->
				console.log userId
				mbUser.get(userId).then((response) ->
					user = response.users[0]
					$rootScope.user = user
					
					if $state.params.redirect
						$state.go($state.params.redirect)

					else
						$state.go('home')
					
				)
			)
			.catch((err) ->
				console.log err 
				$scope.loginFormError = "Authentication failed: #{err.data.error_description}"
			)


		
])