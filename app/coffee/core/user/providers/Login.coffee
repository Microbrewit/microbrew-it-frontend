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

							$rootScope.token = null
							localStorage.removeItem('token')

							$rootScope.user = null

						)
						.then((response) ->
							# Save Token
							token = 
								expires: new Date(response.data['.expires']).getTime()
								token: response.data['access_token']
								refresh: response.data['refresh_token']

							$rootScope.token = token
							localStorage.setItem('token', token)

							return response.data.userName
						)
					
					return promise
				
			return request	
	])