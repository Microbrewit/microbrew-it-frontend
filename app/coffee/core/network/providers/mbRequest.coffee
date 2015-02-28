# API REST methods 
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbRequest', [
	'$http'
	'$rootScope'
	'ApiUrl'
	'ClientUrl'
	'localStorage'
	'notification'
	($http, $rootScope, ApiUrl, ClientUrl, localStorage, notification) ->
		request = {}

		request.get = (requestUrl) ->
			requestUrl = "#{ApiUrl}#{requestUrl}"

			# Add callback
			if requestUrl.indexOf('?') is -1
				requestUrl += "?callback=JSON_CALLBACK"
			else
				requestUrl += "&callback=JSON_CALLBACK"

			console.log "GET: #{requestUrl}"

			$rootScope.loading++

			# Create promise
			promise = $http.jsonp(requestUrl, {})
				.error((data, status, headers) ->
					$rootScope.loading--
					console.error("GET #{requestUrl} gave HTTP #{status}")
					console.error(data)

					if headers('refresh_token')
						token = 
							expires: new Date(headers('.expires')).getTime()
							token: headers('access_token')
							refresh: headers('refresh_token')

						if localStorage.getItem('token')
							localStorage.setItem('token', token)

					notification.add
						title: "Error #{status}" # required
						body: 'Could not get data from server' # optional
						type: 'error'
						time: 5000 # default: null, ms until autoclose
						#medium: 'native' # default: null, native = browser Notification API
				)
				.then((response) ->

					# Save auth token
					if response.headers('refresh_token')
						token = 
							expires: new Date(response.headers('.expires')).getTime()
							token: response.headers('access_token')
							refresh: response.headers('refresh_token')
						
						$rootScope.token = token

						# We only store the token in localstorage if the user chose to be remembered on login
						if localStorage.getItem('token')
							localStorage.setItem('token', token)

					$rootScope.loading--
					return response.data
				)

			return promise

		request.post = (requestUrl, object) ->
			requestUrl = "#{ApiUrl}#{requestUrl}"
			#auth = localStorage.getItem('user')
			$rootScope.loading++

			promise = $http.post(
					requestUrl, 
					object,
					{
						withCredentials: true
						headers: {
							"Authorization": "Bearer #{$rootScope.token.token}"
						}
					}
				)
					.error((data, status, headers) ->
						$rootScope.loading--
						console.log data

						if headers('refresh_token')
							token = 
								expires: new Date(headers('.expires')).getTime()
								token: headers('access_token')
								refresh: headers('refresh_token')

							if localStorage.getItem('token')
								localStorage.setItem('token', token)

						for key, value of data.ModelState
							title = 'Error: ' + value[0]
							body = value[1]

						status = status + ""

						title = "Error" unless title
						title += " (HTTP #{status})" unless status[0] is '4'
						body = "Could not save data." unless body
						body = "We are experiencing server issues. Try again later." if status[0] is '5'

						notification.add
							title: title # required
							body: body # optional
							type: 'error'
							#icon: 'url/to/icon' # optional
							#onClick: callback # optional
							#onClose: callback # optional
							time: 50000 # default: null, ms until autoclose
							#medium: 'native' # default: null, native = browser Notification API
					)
					.then((response) ->

						notification.add
							title: 'Saved'
							body: 'Successfully saved to cloud'
							type: 'success'
							time: 5000
							
						if response.headers('refresh_token')
							token = 
								expires: new Date(response.headers('.expires')).getTime()
								token: response.headers('access_token')
								refresh: response.headers('refresh_token')

							# Save new auth token
							$rootScope.token = token
							localStorage.setItem('token', token)

						$rootScope.loading--
						return response.data
					)
			
			return promise

		request.put = (requestUrl, object) ->
			requestUrl = "#{ApiUrl}#{requestUrl}"
			console.log "mbRequest.put: #{requestUrl}"

			$rootScope.loading++
			request = $http.put(
				requestUrl, 
				object,
				{
					withCredentials: true
					headers: {
						"Authorization": "Bearer #{$rootScope.token.token}"
					}
				}
			)
				.error((data, status, headers) ->
					$rootScope.loading--
					console.error(status)
					console.error(data)

					if headers('refresh_token')
						token = 
							expires: new Date(headers('.expires')).getTime()
							token: headers('access_token')
							refresh: headers('refresh_token')

						if localStorage.getItem('token')
							localStorage.setItem('token', token)

					title = "Could not update"
					if status is 401
						title = "Unauthorized"

					body = "Something went wrong"
					if status is 401
						body = "You do not have access to edit this item."
					notification.add
						title: title
						body: body
						type: 'error'
						time: 2000
				)
				.then((response) ->

					if response.headers('refresh_token')
						token = 
							expires: new Date(response.headers('.expires')).getTime()
							token: response.headers('access_token')
							refresh: response.headers('refresh_token')

						# Save new auth token
						$rootScope.token = token
						localStorage.setItem('token', token)
					
					notification.add
						title: 'Updated Successfully'
						type: 'success'
						time: 500

					$rootScope.loading--
					return response.data
				)
			
			return request

		request.delete = () ->
		return request
])