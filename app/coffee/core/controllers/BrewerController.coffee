mbit = angular.module('Microbrewit')

mbit.controller('BrewerController', ['$scope', 'mbGet', '$stateParams', '_', '$rootScope',
	($scope, get, $stateParams, _, $rootScope) ->

		# We are displaying information about a single user
		if $stateParams.id
			get.user($stateParams.id).then((apiResponse) ->
				# $scope.loading--
				$scope.brewer = apiResponse.users[0]
				$rootScope.showNav = false
				$rootScope.showNav = true if $scope.brewer.username is $scope.user.username

				console.log "#{$scope.brewer.username} is #{$scope.user.username}"
				$scope.isLoggedUser = $scope.brewer.userId is $scope.user.userId.toLowerCase() # Show settings menu if logged user
				$rootScope.bubble = $scope.brewer.gravatar
				$rootScope.title = $scope.brewer.username
			)

		# User search page
		else
			$rootScope.showNav = true
			$rootScope.bubble = ""
			$rootScope.title = "Brewers"
			get.user().then((apiResponse) ->
				$scope.brewers = apiResponse.users
			)
])