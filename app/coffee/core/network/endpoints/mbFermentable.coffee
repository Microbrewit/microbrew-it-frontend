# Wrapper for Fermentable endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbFermentable', [
	'mbRequest'
	'notification'
	'localStorage'
	(mbRequest, notification, localStorage) ->

		endpoint = 'fermentables'
		factory = {}

		factory.get = (id = null, from = 0, size = 20) ->
			if id
				requestUrl = "/#{endpoint}/#{id}"
				return mbRequest.get(requestUrl, {
					returnProperty: endpoint
				})
			else
				requestUrl = "/#{endpoint}"
				return mbRequest.get(requestUrl, { 
					cache: endpoint
					returnProperty: endpoint
					fullscreenLoading: true
				})

		# Update a fermentable
		# @param [Fermentable Object] fermentable
		factory.update = (fermentable) ->
			unless fermentable.id 
				notification.add
					title: "Can't edit fermentable" # required
					body: "You did not select a ingredient to edit, or the ingredient you wanted to edit does not exist." # optional
					type: 'error'
					time: 2000 # default: null, ms until autoclose

			requestUrl = "/#{endpoint}/#{fermentable.id}"

			return mbRequest.put(requestUrl, fermentable)

		# Add a new fermentable
		factory.add = (fermentable) ->
			requestUrl = "/#{endpoint}"

			return mbRequest.post(requestUrl, fermentable)

		# Delete a fermentable
		# @todo implement
		factory.delete = (fermentable) ->

		return factory
])
