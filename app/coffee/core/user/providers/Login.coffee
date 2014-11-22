angular.module('Microbrewit/core/User')
	.service('login', ['$http', '$log', 'ApiUrl', 'ClientUrl', '$rootScope', 'localStorage', ($http, $log, ApiUrl, ClientUrl, $rootScope, localStorage) ->
		
		# promise pattern (login.async().then(-> something))
		doLogin = (username, password, token=false) ->
			
			# # Generate Base64
			# authorization = window.btoa("#{username}:#{password}") unless authorization

			# AUTH using token
			if token
				dataPayload = "grant_type=refresh_token&refresh_token=#{token.refresh}"

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
							# Save Token
							token = 
								expires: new Date(response.data['.expires']).getTime()
								token: response.data['access_token']
								refresh: response.data['refresh_token']

							$rootScope.token = token
							localStorage.setItem('token', token)

							# Save user
							user = 
								userName: response.data.userName
								gravatar: response.data.gravatar
								settings: response.data.settings

							$rootScope.user = user


							return user
						)
					
					return promise
				
			return request	
	])