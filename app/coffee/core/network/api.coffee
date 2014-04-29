# API methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/network/NetworkService', []).
	value('ApiUrl', 'http://api.microbrew.it').
	service('fermentables', ($http, $log, ApiUrl) ->
		@getFermentables = () ->
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

		@setFermentable = (fermentable) ->
			$log.debug "API POST/PUT/UPDATE: Adding/updating #{fermentable}."

	).
	service('yeasts', ($http, $log, ApiUrl) ->
		@getYeasts = () ->
			promise = false
			
			yeasts = 
				async: () ->
					unless promise
						$log.debug 'fetching yeast'

						promise = $http.jsonp(ApiUrl + '/yeasts?callback=JSON_CALLBACK', {})
							.error((data, status) ->
								$log.error(data)
								$log.error(status)
							)
							.then((response) ->
								return response.data
							)
					
					return promise
			
			return yeasts

		@setYeast = (yeast) ->
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