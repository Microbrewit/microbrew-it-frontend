angular.module('Microbrewit/core/User')
	.service('login', ['$http', '$log', 'ApiUrl', 'ClientUrl', '$rootScope', ($http, $log, ApiUrl, ClientUrl, $rootScope) ->


		$http.defaults.headers.options = { 'user_id' : ClientUrl }
		
		# promise pattern (login.async().then(-> something))
		doLogin = (username, password, token=false) ->
			
			# # Generate Base64
			# authorization = window.btoa("#{username}:#{password}") unless authorization

			# AUTH using token
			if token
				# We still have a valid token
				if new Date().getTime() < token.expires
					dataPayload = "grant_type=token&token=#{token.token}"

				# We need to use a refresh token
				else
					dataPayload = "grant_type=refresh&token=#{token.refresh}"

			# AUTH using un/pw
			else if username and password
				dataPayload = "grant_type=password&username=#{username}&password=#{password}"

			dataPayload+="&client_id=#{ClientUrl}"

			request = 
				async: () ->
					unless promise
						promise = $http({
							url: "#{ApiUrl}/token"
							method: "POST"
							#withCredentials: true
							data: dataPayload
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
							token = 
								expires: new Date(response.headers('.expires')).getTime()
								token: response.headers('access_token')
								refresh: response.headers('refresh_token')

							# Save new auth token
							$rootScope.token = token
							localStorage.setItem('token', token)

							return response
						)
					
					return promise
				
			return request	
	])