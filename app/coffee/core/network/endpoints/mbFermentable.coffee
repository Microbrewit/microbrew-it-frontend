# Wrapper for Fermentable endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbFermentable', [
	'mbRequest'
	'notification'
	(mbRequest, notification) ->

		endpoint = '/fermentables'
		factory = {}

		factory.get = (id = null, from = 0, size = 20) ->
			# Check if we have cache
			cache = localStorage.getItem('fermentables') unless id
			return new Promise((fulfill) -> fulfill(cache)) if cache

			if id
				requestUrl = "#{endpoint}/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{endpoint}?callback=JSON_CALLBACK"

			return mbRequest.get(requestUrl)

		# Update a fermentable
		# @param [Fermentable Object] fermentable
		factory.update = (fermentable) ->
			unless fermentable.id 
				notification.add
					title: "Can't edit fermentable" # required
					body: "You did not select a ingredient to edit, or the ingredient you wanted to edit does not exist." # optional
					type: 'error'
					time: 2000 # default: null, ms until autoclose

			requestUrl = "#{endpoint}/#{fermentable.id}"

			return mbRequest.put(requestUrl, fermentable)

		# Add a new fermentable
		factory.add = (fermentable) ->
			requestUrl = "#{endpoint}"

			return mbRequest.post(requestUrl, fermentable)

		# Delete a fermentable
		# @todo implement
		factory.delete = (fermentable) ->

		return factory
])
