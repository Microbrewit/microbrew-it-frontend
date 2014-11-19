angular.module('Microbrewit/core/Notifications')
	.directive('mbMessage', ['notification'
		(notification) ->
			return {
				restrict: 'EA'
				# controllerAs: 'controller'
				# controller: 'MessagesController'
				templateUrl: 'templates/components/messages.html'
				scope: {
					# we don't need anything from other scopes. So create an empty isolate scope.
				}
				link: (scope, elem, attr) ->
					scope.alerts = notification.messages
					scope.closeAlert = (index) -> notification.close(index)
			}
])