# API methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/network/NetworkService', []).
	value('ApiUrl', 'http://api.microbrew.it').
	service('fermentables', ($http, $log, ApiUrl) ->
		@get = (id) ->
			promise = false
			
			fermentables = 
				async: () ->
					unless promise
						$log.debug 'fetching fermentables'

						promise = $http.jsonp(ApiUrl + '/fermentables?callback=JSON_CALLBACK', {})
							.error((data, status) ->
								$log.error(data)
								$log.error(status)
							)
							.then((response) ->
								return response.data
							)

					return promise

			return fermentables;

		@set = (fermentable) ->
			###fermentable:
				id: 123
				supplier:
					id: 432
					name: 'Some Supplier'
				name: 'String'
				ppg: 123
				type: 'Grain'###
			$log.debug "API SET: #{fermentable}."
			
			promise = false
			request = null

			if fermentable.id
				requestUrl = "#{ApiUrl}/fermentables/#{fermentable.id}"
			else
				requestUrl = "#{ApiUrl}/fermentables"

			request = 
				async: () ->
					unless promise
						$log.debug 'ASYNC SET fermentable'

						promise = $http.post(requestUrl, fermentable)
							.error((data, status) ->
								$log.error(data)
								$log.error(status)
							)
							.then((response) ->
								return response.data
							)
					
					return promise
			
			return request

	).
	service('yeasts', ($http, $log, ApiUrl) ->
		@get = (yeastId = false) ->
			promise = false

			if yeastId
				requestUrl = "#{ApiUrl}/yeasts/#{yeastId}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{ApiUrl}/yeasts?callback=JSON_CALLBACK"
			
			request = 
				async: () ->
					unless promise
						$log.debug 'fetching yeast'

						promise = $http.jsonp(requestUrl, {})
							.error((data, status) ->
								$log.error(data)
								$log.error(status)
							)
							.then((response) ->
								return response.data
							)
					
					return promise
			
			return request

		@set = (yeast) ->
			$log.debug "API POST/PUT/UPDATE: Adding/updating #{yeast}."
	).
	service('hops', ($http, $log, ApiUrl) ->
		@getHops = () ->
			promise = false
			
			hops = 
				async: () ->
					unless promise
						$log.debug 'fetching hops'

						promise = $http.jsonp(ApiUrl + '/hops?callback=JSON_CALLBACK', {})
							.error((data, status) ->
								$log.error(data)
								$log.error(status)
							)
							.then((response) ->
								return response.data
							)
					
					return promise

			return hops

		@setHops = (hop) ->
			$log.debug "API POST/PUT/UPDATE: Adding/updating #{hop}."

	).
	service('search', ($http, $log, ApiUrl) ->

	)