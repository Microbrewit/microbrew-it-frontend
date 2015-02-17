# Wrapper for Fermentable endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbFermentable', [
	'mbRequest'
	'notification'
	(mbRequest, notification) ->
])

get = (id = null, from = 0, size = 20) ->
	# Check if we have cache
	cache = localStorage.getItem('fermentables') unless id
	return new Promise((fulfill) -> fulfill(cache)) if cache

	if id
		requestUrl = "/fermentables/#{id}?callback=JSON_CALLBACK"
	else
		requestUrl = "/fermentables?callback=JSON_CALLBACK"

	return @get(requestUrl)

add = () ->

remove = () ->