# Wrapper for Brewery endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbBrewery', [
	'mbRequest'
	'notification'
	(mbRequest, notification) ->
		endpoint = "breweries"
		factory = {}

		factory.getSingle = (id) ->
			unless id
				notification.add
					title: "Can't find brewery" # required
					body: "We can't find the brewery you asked for." # optional
					type: 'error'
					time: 2000 # default: null, ms until autoclose
					#medium: 'native' # default: null, native = browser Notification API
			else
				requestUrl = "/#{endpoint}/#{id}"
				console.log "mbRequest.get = #{mbRequest.get?}"
				return mbRequest.get(requestUrl, {returnProperty: endpoint, fullscreenLoading: true})

		# Get a single or several breweries
		# @param [Object] query
		# @option query [Number] id Id of breweries to get (if single)
		# @option query [Number] from Offset
		# @option query [Number] size Number of items to return
		# @option query [String] query Search string
		factory.get = (query = {}) ->
			# Get specific breweries
			if query.id
				requestUrl = "/#{endpoint}/#{query.id}"

			# Get breweries with query string
			else if query.query?
				query.from ?= 0
				query.size ?= 20
				
				requestUrl = "/#{endpoint}?query=#{query.query}&from=#{query.from}&size=#{query.size}"

			# Get latest added breweries
			else if query.latest
				query.from ?= 0
				query.size ?= 20
				requestUrl = "/#{endpoint}/last?from=#{query.from}&size=#{query.size}"

			# Get breweries
			else
				requestUrl = "/#{endpoint}"

			return mbRequest.get(requestUrl, {returnProperty: endpoint, fullscreenLoading: true})

		factory.add = (brewery) ->
			unless brewery.id 
				notification.add
					title: "Can't edit brewery" # required
					body: "You did not select a beer to edit, or the brewery you wanted to edit does not exist." # optional
					type: 'error'
					time: 2000 # default: null, ms until autoclose

			breweryParsed = parseBreweryPostObject(brewery)
			breweryParsed.id = beer.id
			requestUrl = "/#{endpoint}/#{brewery.id}"

			return mbRequest.post(requestUrl, breweryParsed)

		factory.update = (brewery) ->
			unless brewery.id 
				notification.add
					title: "Can't edit brewery" # required
					body: "You did not select a beer to edit, or the brewery you wanted to edit does not exist." # optional
					type: 'error'
					time: 2000 # default: null, ms until autoclose

			breweryParsed = parseBreweryPostObject(brewery)
			breweryParsed.id = beer.id
			requestUrl = "/#{endpoint}/#{brewery.id}"

			return mbRequest.put(requestUrl, breweryParsed)

		factory.edit = (brewery) ->
			@update(brewery)

		# @todo implement
		factory.addMember = (brewery, user) ->
		# @todo implement
		factory.removeMember = (brewery, user) ->

		return factory

])

# We'll most likely have to do something with breweries before posting
parseBreweryPostObject = (brewery) ->
	return brewery

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