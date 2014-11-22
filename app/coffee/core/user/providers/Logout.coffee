angular.module('Microbrewit/core/User')
	.service('logout', ['$http', '$log', 'ApiUrl', '$rootScope', 'localStorage', ($http, $log, ApiUrl, $rootScope, localStorage) ->
		# Since we use tokens, we know that the token will be invalid soon and that it isnt stored anywhere else
		# Therefore we only need to remove all references to the user object and the token
		() ->
			$rootScope.user = null
			$rootScope.token = null
			localStorage.removeItem('user')
			localStorage.removeItem('token')
	])