# API SEARCH methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.service('mbSearch', ['$http', 'ApiUrl', ($http, ApiUrl) ->
		search = (query, endpoint = "") ->
			if query.length >= 3
				if endpoint isnt ""
					endpoint = "/"+endpoint
				requestUrl = "#{ApiUrl}#{endpoint}?query=#{query}&callback=JSON_CALLBACK"

				promise = $http.jsonp(requestUrl, {})
					.error((data, status) ->
					)
					.then((response) ->
						return response.data
					)
						
				return promise
	])