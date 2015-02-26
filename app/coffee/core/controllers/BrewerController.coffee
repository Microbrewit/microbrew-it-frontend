# Controller for brewers/users
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit').controller('BrewerController', [
	'$state'
	'$rootScope'
	'$scope'
	'mbUser'
	($state, $rootScope, $scope, mbUser) ->

		# Set the state of the controller
		# BeerController is used as a main controller for all beer-related things
		setControllerState = (event, toState, toParams, fromState, fromParams) ->
			currentState = toState?.name 
			currentState ?= $state?.current?.name

			# Reset scope
			$scope.showNav = true
			$scope.bubble = ""
			$scope.title = "Brewers"
			
			# We are displaying information about a single user
			if currentState is 'brewers.single'

				# Determine brewerId
				brewerId = toParams?.id
				brewerId ?= $state.params.id

				# Get brewer
				mbUser.get(brewerId).then((apiResponse) ->
					$scope.brewer = apiResponse.users[0]

					console.log "#{$scope.brewer.username} is #{$scope.user?.username}"
					$scope.isLoggedUser = $scope.brewer.userId is $scope.user?.userId.toLowerCase() # Show settings menu if logged user

					if $scope.brewer.gravatar isnt "" then $scope.bubble = $scope.brewer.gravatar else $scope.bubble = $scope.brewer.username
					$scope.title = $scope.brewer.username
				)

			# User search page
			else if currentState is 'brewers.list'
				
				mbUser.get().then((apiResponse) ->
					$scope.brewers = apiResponse.users
				)

		setControllerState()
		$scope.$on('$stateChangeStart', setControllerState)
])