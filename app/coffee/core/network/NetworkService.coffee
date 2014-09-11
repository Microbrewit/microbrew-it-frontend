# API methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/network/NetworkService', []).
	value('ApiUrl', 'http://api.microbrew.it').
	factory('get', ($http, $log, ApiUrl, $rootScope) ->
		factory = {}
		factory.get = (requestUrl) ->
			console.log requestUrl
			promise = false
			request = 
				async: () ->
					unless promise
						$rootScope.loading++
						$log.debug "fetching #{requestUrl}"

						promise = $http.jsonp(requestUrl, {})
							.error((data, status) ->
								$rootScope.loading--
								$log.error(data)
								$log.error(status)
							)
							.then((response) ->
								$rootScope.loading--
								return response.data
							)

					return promise

			return request

		factory.fermentables = (id = null) ->
			if id
				requestUrl = "#{ApiUrl}/fermentables/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/fermentables?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.yeasts = (id = null) ->
			if id
				requestUrl = "#{ApiUrl}/yeasts/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/yeasts?callback=JSON_CALLBACK"

			return @get(requestUrl)

		factory.hops = (id = null) ->
			if id
				requestUrl = "#{ApiUrl}/hops/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/hops?callback=JSON_CALLBACK"

			return @get(requestUrl)

		return factory

	).
	factory('set', ($http, $log, ApiUrl) ->
		factory = {}
		factory.set = (requestUrl, object) ->
			request = 
				async: () ->
					unless promise
						$log.debug 'ASYNC SET fermentable'
						$rootScope.loading++

						promise = $http.post(requestUrl, object)
							.error((data, status) ->
								$rootScope.loading--
								$log.error(data)
								$log.error(status)
							)
							.then((response) ->
								$rootScope.loading--
								return response.data
							)
					
					return promise
			
			return request
		factory.fermentables = (id = null) ->
			###fermentable:
				id: 123
				supplier:
					id: 432
					name: 'Some Supplier'
				name: 'String'
				ppg: 123
				type: 'Grain'###
		factory.hops = (id = null) ->
		factory.yeasts = (id = null) ->
		return factory
	).

	service('search', ($http, $log, ApiUrl) ->
		@search = (query, endpoint = "") ->
			if query.length >= 3
				promise = false

				if endpoint isnt ""
					endpoint = "/"+endpoint
				requestUrl = "#{ApiUrl}#{endpoint}?query=#{query}&callback=JSON_CALLBACK"
				console.log requestUrl
				
				request = 
					async: () ->
						unless promise
							$log.debug 'search'
							$rootScope.loading++

							promise = $http.jsonp(requestUrl, {})
								.error((data, status) ->
									$rootScope.loading--
									console.log 'ERROR'
									console.log status
									$log.error(data)
									$log.error(status)
								)
								.then((response) ->
									$rootScope.loading--
									if response.data.hits?
										for i in [0...response.data.hits.hits.length]
											response.data.hits.hits[i].endpoint = response.data.hits.hits[i]._type.replace('dto', 's')

									return response.data
								)
						
						return promise
				
				return request	
	)