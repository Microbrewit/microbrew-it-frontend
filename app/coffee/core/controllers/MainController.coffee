mbit = angular.module('Microbrewit')

mbit.controller('MainController', ['$rootScope', '$scope', 'mbUser', '$stateParams', '$state', 'localStorage', 'notification', 'mbGet',
	($rootScope, $scope, mbUser, $stateParams, $state, localStorage, notification, mbGet) ->
		$rootScope.loading = 0

		# Convenience method for checking state
		$scope.is = (name) ->
			return $state.is(name)
		# Convenience method for checking partial state match
		$scope.includes = (name)->
			return $state.includes(name)
		# Convenience method for logging out
		$scope.logout = () ->
			mbUser.logout()
			$state.go('home')

		# Download and store default ingredients
		# These are used in recipe generation and calculators
		unless localStorage.getItem('fermentables')
			mbGet.fermentables().then((fermentables) ->
				localStorage.setItem('fermentables', fermentables)
			)
		unless localStorage.getItem('hops')
			mbGet.hops().then((hops) ->
				console.log 'Storing hops'
				localStorage.setItem('hops', hops)
			)
		unless localStorage.getItem('yeasts')
			mbGet.yeasts().then((yeasts) ->
				console.log 'Storing yeasts'
				localStorage.setItem('yeasts', yeasts)
			)
		unless localStorage.getItem('beerstyles')
			mbGet.beerstyles().then((beerstyles) ->
				console.log 'Storing beerstyles'
				localStorage.setItem('beerstyles', beerstyles)
			)
		unless localStorage.getItem('hopForms')
			mbGet.hopForms().then((hopForms) ->
				console.log 'Storing beerstyles'
				localStorage.setItem('hopForms', hopForms)
			)

		# Autologin if stored token
		token = localStorage.getItem('token')
		if token
			$rootScope.token = token
			mbUser.login(false, false, token).then((userId) -> 
				mbUser.get(userId).then((response) ->
					$rootScope.user = response.users[0]
					$rootScope.user.settings = 
						measurements:
							weight:
								large: 
									name: 'kilograms'
									short: 'kg'
								small: 
									name: 'grams'
									short: 'g'
							liquids: 
								name: 'liters'
								short: 'l'
							temperature: 
								name: 'Celcius'
								short: '°C'
						abv:
							formula: 'microbrewit'
							unit: 
								name: 'specific-gravity'
								short: 'sg'
						bitterness:
							formula: 'tinseth'
							unit: 
								name: 'ibu'
								short: 'ibu'
						colour:
							formula: 'morey'
							unit:
								name: 'srm'
								short: 'srm'
				)
			)

])