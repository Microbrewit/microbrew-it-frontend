user = angular.module('Microbrewit/core/UserService', ['Microbrewit/core/network/NetworkService']).
	service('login', ($http, $log, ApiUrl, $rootScope) ->
		
		# promise pattern (login.async().then(-> something))
		doLogin = (username, password, authorization=false) ->
			
			# Generate Base64
			authorization = window.btoa("#{username}:#{password}") unless authorization

			request = 
				async: () ->
					unless promise
						promise = $http({
							url: "#{ApiUrl}/users/login"
							method: "POST"
							withCredentials: true
							headers: {
								'Authorization': "Basic #{authorization}"
							}
						})
						.error((data, status) ->
							$log.error(data)
							$log.error(status)

							console.log 'ERROR'
							console.log status
							console.log data
						)
						.then((response) ->
							$rootScope.user = response.data
							$rootScope.user.auth = authorization
							$rootScope.token =
								expires: new Date()
								token: response.headers('authorization-token')
							return response
						)
					
					return promise
				
			return request	
	).
	service('logout', ($http, $log, ApiUrl, $rootScope) ->
		# Since we use tokens, we know that the token will be invalid soon and that it isnt stored anywhere else
		# Therefore we only need to remove all references to the user object and the token
		if $rootScope.user?.auth
			$rootScope.user = null
			$rootScope.token = null
			$localStorage.removeItem('user')
	).
	service('update', () ->)
