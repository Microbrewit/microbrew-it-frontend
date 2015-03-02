# Wrapper for Hop endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbHop', [
	'mbRequest'
	'notification'
	(mbRequest, notification) ->
		endpoint = '/hops'
		factory = {}

		factory.get = (id = null, from = 0, size = 20) ->
			# Check if we have cache
			cache = localStorage.getItem('hops') unless id
			return new Promise((fulfill) -> fulfill(cache)) if cache

			if id
				requestUrl = "#{endpoint}/#{id}?callback=JSON_CALLBACK"
			else
				requestUrl = "#{endpoint}?callback=JSON_CALLBACK"

			return mbRequest.get(requestUrl)

		# Update a ingredient
		# @param [ingredient Object] ingredient
		factory.update = (ingredient) ->
			unless ingredient.id 
				notification.add
					title: "Can't edit ingredient" # required
					body: "You did not select a ingredient to edit, or the ingredient you wanted to edit does not exist." # optional
					type: 'error'
					time: 2000 # default: null, ms until autoclose

			requestUrl = "#{endpoint}/#{ingredient.id}"

			return mbRequest.put(requestUrl, ingredient)

		# Add a new ingredient
		factory.add = (ingredient) ->
			requestUrl = "#{endpoint}"

			return mbRequest.post(requestUrl, ingredient)

		# Delete a ingredient
		# @todo implement
		factory.delete = (ingredient) ->

		return factory
])