# Wrapper for Yeast endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbYeast', [
	'mbGet'
	'mbPost'
	'mbPut'
	'notification'
	(mbGet, mbPost, mbPut, notification) ->
])

yeasts = (id = null, from = 0, size = 20) ->
	# Check if we have cache
	cache = localStorage.getItem('yeasts') unless id
	return new Promise((fulfill) -> fulfill(cache)) if cache

	if id
		requestUrl = "#{ApiUrl}/yeasts/#{id}?callback=JSON_CALLBACK"
	else
		requestUrl = "#{ApiUrl}/yeasts?callback=JSON_CALLBACK"

	return @get(requestUrl)