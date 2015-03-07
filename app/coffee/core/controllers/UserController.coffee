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
	'mbAccount'
	($scope, mbUser, $state, localStorage, $rootScope, convert, mbAccount) ->

		setupSettings = () ->
			console.log 'weightLarge: ' + $rootScope.user?.settings?.largeWeight
			$scope.weightAvailable = [$scope.user?.settings?.largeWeight].concat(convert.available($scope.user?.settings?.largeWeight))
			$scope.liquidsAvailable = [$scope.user?.settings?.liquid].concat(convert.available($scope.user?.settings?.liquid))
			$scope.temperaturesAvailable = [$scope.user?.settings?.temperature].concat(convert.available($scope.user?.settings?.temperature))
			$scope.abvFormulasAvailable = ['microbrewit']
			$scope.abvUnitsAvailable = ['sg']
			$scope.bitternessFormulasAvailable = ['tinseth']
			$scope.bitternessUnitsAvailable = ['ibu']
			$scope.colourFormulasAvailable = ['morey']
			$scope.colourUnitsAvailable = ['srm']

			console.log $scope.user?.settings?.liquid

			$scope.settings = {
				largeWeight: $scope.weightAvailable[0]
				smallWeight: $scope.weightAvailable[$scope.weightAvailable.indexOf($scope.user?.settings?.smallWeight)]
				liquid: $scope.liquidsAvailable[0]
				temperature: $scope.temperaturesAvailable[0]
				abv:
					formula: $scope.abvFormulasAvailable[$scope.abvFormulasAvailable.indexOf($scope.user.settings.abv.formula)]
					unit: $scope.abvUnitsAvailable[$scope.abvUnitsAvailable.indexOf($scope.user.settings.abv.unit)]
				bitterness:
					formula: $scope.bitternessFormulasAvailable[$scope.bitternessFormulasAvailable.indexOf($scope.user.settings.bitterness.formula)]
					unit: $scope.bitternessUnitsAvailable[$scope.bitternessUnitsAvailable.indexOf($scope.user.settings.bitterness.unit)]
				colour:
					formula: $scope.colourFormulasAvailable[$scope.colourFormulasAvailable.indexOf($scope.user.settings.colour.formula)]
					unit: $scope.colourUnitsAvailable[$scope.colourUnitsAvailable.indexOf($scope.user.settings.colour.unit)]
			}

		console.log $scope.user

		if $state.current.name is 'account.settings'

			$scope.updateUser = () ->
				$scope.user.settings = _.cloneDeep $scope.settings

				mbAccount.update($scope.user).then((obj) -> console.log obj)

			if $scope.user?.settings?
				setupSettings()
			else
				watcher = $scope.$watch('user.settings', (newValue, oldValue) ->
					if newValue
						watcher()
						setupSettings()
				)

		if $state.current.name is 'account.register'
			if $scope.user?.settings?
				setupSettings()
			$scope.account =
				username: ""
				password: "null"
				confirmPassword: "null"
				email: ""
				settings: null

			$scope.registerUser = () ->

				$scope.account.settings = _.cloneDeep $scope.settings

				mbAccount.register($scope.account).then()

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
				mbUser.getSingle(userId).then((response) ->
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