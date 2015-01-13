# API SEARCH methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.service('mbSearch', ['$http', '$log', 'ApiUrl', '$rootScope', ($http, $log, ApiUrl, $rootScope) ->
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
									return response.data
								)
						
						return promise
				
				return request	
	])