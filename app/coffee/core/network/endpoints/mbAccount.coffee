# Wrapper for Account endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbAccount', [
	'mbRequest'
	'notification'
	'$rootScope'
	(mbRequest, notification, $rootScope) ->
		factory = {}
		endpoint = "/Account"

		# Register a new user
		# @param [Object] userObj
		# @option userObj [string] username (required)
		# @option userObj [string] email (required)
		# @option userObj [array] brewery
		# @option userObj [object] settings
		# @option userObj [string] password (required)
		# @option userObj [string] confirmPassword (required)
		# @option userObj [object] geoLocation
		factory.register = (userObj) ->
			if userObj.username? and userObj.email? and userObj.password? and userObj.confirmPassword?
				mbRequest.post("#{endpoint}/Register", userObj)
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
					#localStorage.removeItem('token')
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
						title: "Welcome back, #{response.data.username}" # required
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
			else
				notification.add
					title: "Could not register user"
					body: "username, email or password missing."
					type: 'error'
					time: 2000

		# Resend email verification
		# @param [String] username
		factory.resend = (username) ->
			mbRequest.get("#{endpoint}/resend", {username: username})

		# Forgot password
		# @param [string] email
		factory.forgot = (email) ->
			mbRequest.post("#{endpoint}/forgot", {Email: email})

		# Update user
		factory.update = (userObj) ->
			if userObj.username?
				return mbRequest.put("#{endpoint}/#{userObj.username}")
			else
				notification.add
					title: "Could not update user"
					body: ""
					type: 'error'
					time: 2000

		factory.edit = (userObj) ->
			@update(userObj)

		factory.resend = (userObj) ->
			if $rootScope.user?.username and userObj.username?
				mbRequest.post("#{endpoint}/resend?username=#{userObj.username}")

		return factory
])
