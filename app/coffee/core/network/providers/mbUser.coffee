# API USER methods
# 
# Methods for gettings, setting, logging in and out users.
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbUser', [
	'$http'
	'mbGet'
	'mbPost'
	'ClientUrl'
	'$rootScope'
	'localStorage'
	'notification'
	'ApiUrl'
	($http, mbGet, mbPost, ClientUrl, $rootScope, localStorage, notification, ApiUrl) ->
		factory = {}

		# Get a single user (by id) or a group of users (no ID)
		# @param [String] userId ID of user to get (same as username)
		factory.get = (id = null) ->
			if id
				requestUrl = "#{ApiUrl}/users/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/users?callback=JSON_CALLBACK"

			return mbGet.get(requestUrl)

		# Search in users endpoint
		# @param [String] query Querystring to search for
		factory.search = (query) ->
			requestUrl = "#{endpoint}?query=#{query}&callback=JSON_CALLBACK"

			return mbGet.get(reuestUrl)

		# Login a user, we need either username + password or a token object
		# @param [String] username
		# @param [String] password
		# @param [Object] token
		factory.login = (username, password, token=false) ->

			console.log "username: #{username}"
			# AUTH using token
			if token
				dataPayload = "grant_type=refresh_token&refresh_token=#{token.refresh}"

			# AUTH using un/pw
			else if username and password
				dataPayload = "grant_type=password&username=#{username}&password=#{password}"

			dataPayload+="&client_id=#{ClientUrl}"

			console.log dataPayload

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
				console.log 'We received error'
				notification.add
					title: 'Authentication error' # required
					body: 'Wrong username/password' # optional
					type: 'error full-width'
					time: 50000 # default: null, ms until autoclose
					#medium: 'native' # default: null, native = browser Notification API

			)
			.then((response) ->
				notification.add
					title: 'Welcome back!' # required
					#body: 'Wrong username/password' # optional
					type: 'success'
					time: 2000 # default: null, ms until autoclose
					#medium: 'native' # default: null, native = browser Notification API

				# Save Token
				console.log 'we received then'
				console.log response
				token = 
					expires: new Date(response.data['.expires']).getTime()
					token: response.data['access_token']
					refresh: response.data['refresh_token']

				$rootScope.token = token
				localStorage.setItem('token', token)

				return response.data.username
			)
			
			return promise

		# Since we use tokens, we know that the token will be invalid soon and that it isnt stored anywhere else
		# Therefore we only need to remove all references to the user object and the token
		factory.logout = () ->
			$rootScope.user = null
			$rootScope.token = null
			localStorage.removeItem('user')
			localStorage.removeItem('token')

		# Update user
		# @todo Implement
		factory.update = () ->
			console.log 'USER UPDATE NOT IMPLEMENTED'

		return factory
])