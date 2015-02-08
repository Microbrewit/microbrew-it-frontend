# Wrapper for Hop endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbHop', [
	'mbGet'
	'mbPost'
	'mbPut'
	'notification'
	(mbGet, mbPost, mbPut, notification) ->
])

hops = (id = null, from = 0, size = 20) ->
	console.log "APIURL: #{ApiUrl}"
	# Check if we have cache
	cache = localStorage.getItem('hops') unless id
	return new Promise((fulfill) -> fulfill(cache)) if cache

	if id
		requestUrl = "#{ApiUrl}/hops/#{id}?callback=JSON_CALLBACK"
	else
		requestUrl = "#{ApiUrl}/hops?callback=JSON_CALLBACK"

	return @get(requestUrl)