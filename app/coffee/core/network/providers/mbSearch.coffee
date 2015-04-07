# API SEARCH methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.service('mbSearch', ['mbRequest', (mbRequest) ->
		search = (query, endpoint = "") ->
			if query.length >= 3
				if endpoint isnt ""
					endpoint = "/"+endpoint
				requestUrl = "#{endpoint}?query=#{query}"

				return mbRequest.get(requestUrl)
	])