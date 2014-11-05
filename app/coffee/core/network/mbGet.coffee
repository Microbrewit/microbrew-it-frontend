# API GET methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.factory('mbGet', ['$http', '$log', 'ApiUrl', '$rootScope', 'sessionStorage', ($http, $log, ApiUrl, $rootScope, sessionStorage) ->
		factory = {}
		factory.get = (requestUrl) ->
			console.log "GET: #{requestUrl}"
			promise = false
			request = 
				async: () ->
					unless promise
						$rootScope.loading++

						promise = $http.jsonp(requestUrl, {})
							.error((data, status) ->
								$rootScope.loading--
								console.error(status)
								console.error(data)

							)
							.then((response) ->

								# Save auth token
								authToken = response.headers('authorization-token')
								if authToken?
									$rootScope.token =
										expires: new Date()
										token: authToken

								$rootScope.loading--
								return response.data
							)

					return promise

			return request

		factory.user = (id = null) ->
			if id
				requestUrl = "#{ApiUrl}/users/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/users?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.fermentables = (id = null, from = 0, size = 20) ->
			if id
				requestUrl = "#{ApiUrl}/fermentables/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/fermentables?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.yeasts = (id = null, from = 0, size = 20) ->
			if id
				requestUrl = "#{ApiUrl}/yeasts/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/yeasts?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.hops = (id = null, from = 0, size = 20) ->
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