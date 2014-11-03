# API GET methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.factory('mbGet', ['$http', '$log', 'ApiUrl', '$rootScope', 'sessionStorage', ($http, $log, ApiUrl, $rootScope, sessionStorage) ->
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

		factory.user = (id = null) ->
			if id
				requestUrl = "#{ApiUrl}/users/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/users?callback=JSON_CALLBACK"

			return @get(requestUrl)

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

	])