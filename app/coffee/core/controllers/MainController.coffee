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
			)

		# search logic
		$scope.search = (searchTerm) ->
			$state.go('searchWithTerm', { searchTerm: searchTerm })
])