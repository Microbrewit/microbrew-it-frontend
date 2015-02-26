mbit = angular.module('Microbrewit')

mbit.controller('MainController', ['$rootScope', '$scope', 'mbUser', '$stateParams', '$state', 'localStorage', 'notification', 'mbGet',
	($rootScope, $scope, mbUser, $stateParams, $state, localStorage, notification, mbGet) ->
		$rootScope.loading = 0

		#Custom $off function to un-register the listener.
		$rootScope.$off = (name, listener)  ->
			namedListeners = $rootScope.$$listeners[name]
			if (namedListeners) 
				# Loop through the array of named listeners and remove them from the array.
				for i in [0...namedListeners.length]
					if namedListeners[i] is listener
						return namedListeners.splice(i, 1)

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

		# notification.add
		# 	type: 'question'
		# 	title: 'Test'
		# 	body: 'Test body'
		# 	accept: (index) -> 
		# 		console.log('test accept')
		# 		$scope.$$childHead.closeAlert(index)
		# 	decline: (index) -> 
		# 		console.log('test decline')
		# 		$scope.$$childHead.closeAlert(index)

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

		unless $rootScope.user?.settings is {}
			$rootScope.user =
				settings: 
					largeWeight: 'kg'
					smallWeight: 'grams'
					liquid: 'liters'
					temperature: 'celcius'
					abv:
						formula: 'microbrewit'
						unit: 'sg'
					bitterness:
						formula: 'tinseth'
						unit: 'ibu'
					colour:
						formula: 'morey'
						unit: 'srm'

		# Autologin if stored token
		token = localStorage.getItem('token')
		if token
			$rootScope.token = token
			mbUser.login(false, false, token).then((userId) -> 
				mbUser.get(userId).then((response) ->
					$rootScope.user = response.users[0]
					unless $rootScope.user.settings?.largeWeight?
						$rootScope.user.settings = 
							largeWeight: 'kg'
							smallWeight: 'grams'
							liquid: 'liters'
							temperature: 'celcius'
							abv:
								formula: 'microbrewit'
								unit: 'sg'
							bitterness:
								formula: 'tinseth'
								unit: 'ibu'
							colour:
								formula: 'morey'
								unit: 'srm'
				)
			)

])