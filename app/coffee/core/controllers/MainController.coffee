mbit = angular.module('Microbrewit')

mbit.controller('MainController', ['$scope', 'login', 'logout', '$stateParams', '$state', 'localStorage', 'urgentMessage', 'notification'
	($scope, login, logout, $stateParams, $state, localStorage, urgentMessage, notification) ->
		setTimeout(->
			notification
				title: 'Test notification'
				body: 'This is simply a test to see if native notifications work.'
				onclick: () -> console.log '??'
				onclose: () -> console.log '!??'
		, 1000)
		# should we log in a remembered user?
		user = localStorage.getItem('user')
		if user and user.auth isnt ""
			console.log user.auth
			login(null, null, user.auth).async().then(
				(response) => 
			)

		# search logic
		$scope.search = (searchTerm) ->
			$state.go('searchWithTerm', { searchTerm: searchTerm })
])