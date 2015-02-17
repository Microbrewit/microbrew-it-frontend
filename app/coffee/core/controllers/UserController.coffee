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
	'convert'
	($scope, mbUser, $state, localStorage, $rootScope, convert) ->

		setupSettings = () ->
			console.log 'weightLarge: ' + $rootScope.user?.settings?.largeWeight
			$scope.weightAvailable = [$scope.user?.settings?.largeWeight].concat(convert.available($scope.user?.settings?.largeWeight))

			$scope.settings = {
				largeWeight: $scope.weightAvailable[0]
				smallWeight: $scope.weightAvailable[$scope.weightAvailable.indexOf($scope.user?.settings?.smallWeight)]
			}

			$scope.liquidAvailable = convert.available('liters').concat(['liters'])

		if $state.current.name is 'account.settings'

			if $scope.user?.settings?
				setupSettings()
			else
				watcher = $scope.$watch('user.settings', (newValue, oldValue) ->
					if newValue
						watcher()
						setupSettings()
				)

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
		$scope.login = (thise) ->
			console.log thise
			username = $scope.username or $scope.$$childHead.username
			password = $scope.password or $scope.$$childHead.password
			console.log $scope
			mbUser.login(username, password).then((userId) ->
				mbUser.get(userId).then((response) ->
					user = response.users[0]
					$rootScope.user = user
					
					if $state.params.redirect
						$state.go($state.params.redirect)

					else if $state.is('account.login') or $state.is('user.login')
						$state.transitionTo('home')
					
				)
			)
			.catch((err) ->
				$scope.loginFormError = "Authentication failed: #{err.data.error_description}"
			)


		
])