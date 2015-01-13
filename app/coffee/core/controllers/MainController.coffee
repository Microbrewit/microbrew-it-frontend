mbit = angular.module('Microbrewit')

mbit.controller('MainController', ['$rootScope', '$scope', 'login', 'logout', '$stateParams', '$state', 'localStorage', 'notification', 'mbGet',
	($rootScope, $scope, login, logout, $stateParams, $state, localStorage, notification, mbGet) ->
		$rootScope.loading = 0

		# $rootScope.user = {}
		# $rootScope.user.settings = 
		# 	measurements:
		# 		weight:
		# 			large: 
		# 				name: 'kilograms'
		# 				short: 'kg'
		# 			small: 
		# 				name: 'grams'
		# 				short: 'g'
		# 		liquids: 
		# 			name: 'liters'
		# 			short: 'l'
		# 		temperature: 
		# 			name: 'Celcius'
		# 			short: '°C'
		# 	abv:
		# 		formula: 'microbrewit'
		# 		unit: 
		# 			name: 'specific-gravity'
		# 			short: 'sg'
		# 	bitterness:
		# 		formula: 'tinseth'
		# 		unit: 
		# 			name: 'ibu'
		# 			short: 'ibu'
		# 	colour:
		# 		formula: 'morey'
		# 		unit:
		# 			name: 'srm'
		# 			short: 'srm'

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

		# should we log in a remembered user?
		user = localStorage.getItem('user')
		if user
			$rootScope.user = user

		token = localStorage.getItem('token')
		console.log token
		if token
			login(false, false, token).async().then(
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