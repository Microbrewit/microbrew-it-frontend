mbit = angular.module('Microbrewit')

mbit.controller('MainController', ['$scope', 'login', 'logout', '$stateParams', '$state', 'localStorage'
	($scope, login, logout, $stateParams, $state, localStorage) ->
		console.log 'MainController active'

		# should we log in a remembered user?
		user = localStorage.getItem('user')
		if user and user.auth isnt ""
			console.log user.auth
			login(null, null, user.auth).async().then(
				(response) -> 
					console.log 'logged in'
			)

		# search logic
		$scope.search = (searchTerm) ->
			$state.go('searchWithTerm', { searchTerm: searchTerm })

		
])