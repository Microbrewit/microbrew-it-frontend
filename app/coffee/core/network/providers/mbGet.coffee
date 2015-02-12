# API GET methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.factory('mbGet', ['$http', '$log', 'ApiUrl', '$rootScope', 'sessionStorage', 'localStorage', 'notification', ($http, $log, ApiUrl, $rootScope, sessionStorage, localStorage, notification) ->
		factory = {}

		factory.get = (requestUrl) ->
			requestUrl = "#{requestUrl}"
			console.log "GET: #{requestUrl}"
			$rootScope.loading++

			# Create promise
			promise = $http.jsonp(requestUrl, {})
				.error((data, status) ->
					$rootScope.loading--
					console.error(status)
					console.error(data)
					notification.add
						title: 'Error' # required
						body: 'Could not get data from server' # optional
						type: 'error'
						#icon: 'url/to/icon' # optional
						#onClick: callback # optional
						#onClose: callback # optional
						time: 5000 # default: null, ms until autoclose
						#medium: 'native' # default: null, native = browser Notification API
				)
				.then((response) ->

					# Save auth token
					if response.headers('access_token')
						token = 
							expires: new Date(response.headers('.expires')).getTime()
							token: response.headers('access_token')
							refresh: response.headers('refresh_token')
						
						$rootScope.token = token

						# We only store the token in localstorage if the user chose to be remembered on login
						if localStorage.getItem('token')
							localStorage.setItem('token', token)

					$rootScope.loading--
					console.log response.data
					return response.data
				)

			return promise

		factory.brewery = (id = null) ->
			if id
				requestUrl = "#{ApiUrl}/breweries/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/breweries?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.fermentables = (id = null, from = 0, size = 20) ->
			# Check if we have cache
			cache = localStorage.getItem('fermentables') unless id
			return new Promise((fulfill) -> fulfill(cache)) if cache

			if id
				requestUrl = "#{ApiUrl}/fermentables/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/fermentables?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.yeasts = (id = null, from = 0, size = 20) ->
			# Check if we have cache
			cache = localStorage.getItem('yeasts') unless id
			return new Promise((fulfill) -> fulfill(cache)) if cache

			if id
				requestUrl = "#{ApiUrl}/yeasts/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/yeasts?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.hops = (id = null, from = 0, size = 20) ->
			# Check if we have cache
			cache = localStorage.getItem('hops') unless id

			if cache
				console.log 'hops cache'
				console.log cache
				try
					return new Promise((fulfill) -> fulfill(cache))
				catch e 
					console.log e

			if id
				requestUrl = "#{ApiUrl}/hops/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/hops?callback=JSON_CALLBACK"

			return @get(requestUrl)

		# Query Object:
		# id
		# from
		# size
		# query
		factory.beers = (query = {}) ->
			endpoint = 'beers'
			# Get specific beer
			if query.id
				requestUrl = "#{ApiUrl}/#{endpoint}/#{query.id}?callback=JSON_CALLBACK"

			# Get beer with query string
			else if query.query?
				query.from ?= 0
				query.size ?= 20
				
				requestUrl = "#{ApiUrl}/#{endpoint}?query=#{query.query}&from=#{query.from}&size=#{query.size}&callback=JSON_CALLBACK"

			# Get latest added beers
			else if query.latest
				query.from ?= 0
				query.size ?= 20
				requestUrl = "#{ApiUrl}/#{endpoint}/last?from=#{query.from}&size=#{query.size}&callback=JSON_CALLBACK"

			# Get beers
			else
				requestUrl = "#{ApiUrl}/#{endpoint}?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.breweries = (query = {}) ->
			endpoint = 'breweries'
			# Get specific beer
			if query.id
				requestUrl = "#{ApiUrl}/#{endpoint}/#{query.id}?callback=JSON_CALLBACK"

			# Get beer with query string
			else if query.query?
				query.from ?= 0
				query.size ?= 20
				
				requestUrl = "#{ApiUrl}/#{endpoint}?query=#{query.query}&from=#{query.from}&size=#{query.size}&callback=JSON_CALLBACK"

			# Get latest added beers
			else if query.latest
				query.from ?= 0
				query.size ?= 20
				requestUrl = "#{ApiUrl}/#{endpoint}/last?from=#{query.from}&size=#{query.size}&callback=JSON_CALLBACK"

			# Get beers
			else
				requestUrl = "#{ApiUrl}/#{endpoint}?callback=JSON_CALLBACK"

			return @get(requestUrl)

		# Query Object:
		# id
		# from
		# size
		# query
		factory.suppliers = (query = {}) ->
			endpoint = 'suppliers'

			if query.id
				requestUrl = "#{ApiUrl}/#{endpoint}/#{query.id}?callback=JSON_CALLBACK"

			else if query.query?
				query.from ?= 0
				query.size ?= 20
				
				requestUrl = "#{ApiUrl}/#{endpoint}?query=#{query.query}&from=#{query.from}&size=#{query.size}&callback=JSON_CALLBACK"

			else
				requestUrl = "#{ApiUrl}/#{endpoint}?callback=JSON_CALLBACK"

			return @get(requestUrl)

				# Query Object:
		# id
		# from
		# size
		# query
		factory.beerstyles = (query = {}) ->
			endpoint = 'beerstyles'

			if query.id
				requestUrl = "#{ApiUrl}/#{endpoint}/#{query.id}?callback=JSON_CALLBACK"

			else if query.query?
				query.from ?= 0
				query.size ?= 20
				
				requestUrl = "#{ApiUrl}/#{endpoint}?query=#{query.query}&from=#{query.from}&size=#{query.size}&callback=JSON_CALLBACK"

			else
				
				# Do we have this cached?
				cache = localStorage.getItem('beerstyles')
				return new Promise((fulfill) -> fulfill(cache)) if cache
				
				requestUrl = "#{ApiUrl}/#{endpoint}?callback=JSON_CALLBACK"

			return @get(requestUrl)

		# Query Object:
		# id
		# from
		# size
		# query
		factory.glasses = (query = {}) ->
			endpoint = 'glasses'

			if query.id
				requestUrl = "#{ApiUrl}/#{endpoint}/#{query.id}?callback=JSON_CALLBACK"

			else if query.query?
				query.from ?= 0
				query.size ?= 20
				
				requestUrl = "#{ApiUrl}/#{endpoint}?query=#{query.query}&from=#{query.from}&size=#{query.size}&callback=JSON_CALLBACK"

			else

				# Do we have this cached?
				cache = localStorage.getItem('beerstyles') unless id
				return new Promise((fulfill) -> fulfill(cache)) if cache
				
				requestUrl = "#{ApiUrl}/#{endpoint}?callback=JSON_CALLBACK"

			return @get(requestUrl)

		# Query Object:
		# id
		# from
		# size
		# query
		factory.origin = (query = {}) ->
			endpoint = 'origins'

			if query.id
				requestUrl = "#{ApiUrl}/#{endpoint}/#{query.id}?callback=JSON_CALLBACK"

			else if query.query?
				query.from ?= 0
				query.size ?= 20
				
				requestUrl = "#{ApiUrl}/#{endpoint}?query=#{query.query}&from=#{query.from}&size=#{query.size}&callback=JSON_CALLBACK"

			else
				requestUrl = "#{ApiUrl}/#{endpoint}?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.hopForms = () ->
			# Do we have this cached?
			cache = localStorage.getItem('hopForms')
			return new Promise((fulfill) -> fulfill(cache)) if cache

			endpoint = 'hops/forms'
			requestUrl = "#{ApiUrl}/#{endpoint}?callback=JSON_CALLBACK"
			return @get(requestUrl)

		# Query Object:
		# id
		# from
		# size
		# query
		factory.suppliers = (query = {}) ->
			endpoint = 'suppliers'

			if query.id
				requestUrl = "#{ApiUrl}/#{endpoint}/#{query.id}?callback=JSON_CALLBACK"

			else if query.query?
				query.from ?= 0
				query.size ?= 20
				
				requestUrl = "#{ApiUrl}/#{endpoint}?query=#{query.query}&from=#{query.from}&size=#{query.size}&callback=JSON_CALLBACK"

			else
				requestUrl = "#{ApiUrl}/#{endpoint}?callback=JSON_CALLBACK"

			return @get(requestUrl)

		
		return factory


	])