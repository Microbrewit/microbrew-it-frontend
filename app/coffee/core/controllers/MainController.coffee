mbit = angular.module('Microbrewit')

mbit.controller('MainController', ['$rootScope', '$scope', 'login', 'logout', '$stateParams', '$state', 'localStorage', 'notification'
	($rootScope, $scope, login, logout, $stateParams, $state, localStorage, notification) ->
		$rootScope.loading = 0
		i = 0
		notification.add
			title: "#{i++} Test notification"
			body: 'This is simply a test to see if native notifications work.'
			time: 10000
			type: 'notification'
			medium: 'other'
		# should we log in a remembered user?
		user = localStorage.getItem('user')
		if user and user.auth isnt ""
			login(null, null, user.auth).async().then(
				(response) => 
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



		# search logic
		$scope.search = (searchTerm) ->
			$state.go('searchWithTerm', { searchTerm: searchTerm })
])