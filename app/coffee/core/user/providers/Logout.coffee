angular.module('Microbrewit/core/User')
	.service('logout', ['$http', '$log', 'ApiUrl', '$rootScope', ($http, $log, ApiUrl, $rootScope) ->
		# Since we use tokens, we know that the token will be invalid soon and that it isnt stored anywhere else
		# Therefore we only need to remove all references to the user object and the token
		if $rootScope.user?.auth
			$rootScope.user = null
			$rootScope.token = null
			$localStorage.removeItem('user')
	])