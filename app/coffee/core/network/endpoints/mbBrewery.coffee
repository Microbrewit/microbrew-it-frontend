# Wrapper for Brewery endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbBrewery', [
	'mbGet'
	'mbPost'
	'mbPut'
	'notification'
	(mbGet, mbPost, mbPut, notification) ->

])

endpoint = 'breweries'

getBrewery = (id = null) ->
	if id
		requestUrl = "/breweries/#{id}?callback=JSON_CALLBACK"
	else
		requestUrl = "/breweries?callback=JSON_CALLBACK"

	return @get(requestUrl)

getBreweries = (query) ->

addBrewery = () ->

updateBrewery = () ->

addMember = (brewery, user) ->

removeMember = (brewery, user) ->

# API	Description
# GET breweries	
# No documentation available.
# GET breweries/{id}	
# No documentation available.
# PUT breweries/{id}	
# No documentation available.
# POST breweries	
# No documentation available.
# DELETE breweries/{id}	
# No documentation available.
# DELETE breweries/{id}/members/{username}	
# No documentation available.
# GET breweries/{id}/members/{username}	
# No documentation available.
# GET breweries/{id}/members	
# No documentation available.
# PUT breweries/{id}/members/{username}	
# No documentation available.
# POST breweries/{id}/members	
# No documentation available.
# GET breweries/es	
# No documentation available.
# GET breweries?query={query}&from={from}&size={size}	
# No documentation available.