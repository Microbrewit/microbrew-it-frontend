angular.module('Microbrewit/core/User')
	.service('login', ['$http', '$log', 'ApiUrl', 'ClientUrl', '$rootScope', ($http, $log, ApiUrl, ClientUrl, $rootScope) ->


		$http.defaults.headers.options = { 'user_id' : ClientUrl }
		
		# promise pattern (login.async().then(-> something))
		doLogin = (username, password, authorization=false) ->
			
			# Generate Base64
			authorization = window.btoa("#{username}:#{password}") unless authorization

			request = 
				async: () ->
					unless promise
						promise = $http({
							url: "#{ApiUrl}/token"
							method: "POST"
							#withCredentials: true
							data: "grant_type=password&username=#{username}&password=#{password}&client_id=#{ClientUrl}"
							headers:
								"Content-Type": "application/x-www-form-urlencoded"
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
							console.log $rootScope.user
							$rootScope.user.auth = authorization
							$rootScope.token =
								expires: new Date(response.headers('.expires')).getTime()
								token: response.headers('access_token')
								refresh: response.headers('refresh_token')
							return response
						)
					
					return promise
				
			return request	
	])