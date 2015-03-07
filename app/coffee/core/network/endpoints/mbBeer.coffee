# API BEER API methods 
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbBeer', [
	'mbRequest'
	'notification'
	(mbRequest, notification) ->
		factory = {}
		endpoint = 'beers'

		# Get a single or several beers
		# @param [Object] query
		# @option query [Number] id Id of beer to get (if single)
		# @option query [Number] from Offset
		# @option query [Number] size Number of items to return
		# @option query [String] query Search string
		factory.get = (query = {}) ->
			# Get specific beer
			if query.id
				requestUrl = "/#{endpoint}/#{query.id}"

				options =
					fullscreenLoading: true
					returnProperty: endpoint

			# Get beer with query string
			else if query.query?
				query.from ?= 0
				query.size ?= 20
				
				requestUrl = "/#{endpoint}?query=#{query.query}&from=#{query.from}&size=#{query.size}"
				options =
					returnProperty: endpoint
					fullscreenLoading: true

			# Get latest added beers
			else if query.latest
				query.from ?= 0
				query.size ?= 20
				requestUrl = "/#{endpoint}/last?from=#{query.from}&size=#{query.size}"

				options =
					returnProperty: endpoint
					fullscreenLoading: true

			# Get beers
			else
				requestUrl = "/#{endpoint}"

				options =
					returnProperty: endpoint
					fullscreenLoading: true

			return mbRequest.get(requestUrl, options)

		# Get a single beer. Works if you need to be absolutely sure that you only get a single beer
		# @param [Number] id
		factory.getSingle = (id) ->
			unless id
				notification.add
					title: "Can't find beer" # required
					body: "We can't find the beer you asked for." # optional
					type: 'error'
					time: 2000 # default: null, ms until autoclose
					#medium: 'native' # default: null, native = browser Notification API
			else
				requestUrl = "/#{endpoint}/#{id}"
				console.log "mbRequest.get = #{mbRequest.get?}"
				return mbRequest.get(requestUrl)

		# Update a beer
		# @param [Beer Object] beer
		factory.update = (beer) ->
			unless beer.id 
				notification.add
					title: "Can't edit beer" # required
					body: "You did not select a beer to edit, or the beer you wanted to edit does not exist." # optional
					type: 'error'
					time: 2000 # default: null, ms until autoclose

			beerParsed = parseBeerPostObject(beer)
			beerParsed.id = beer.id
			requestUrl = "/#{endpoint}/#{beer.id}"

			return mbRequest.put(requestUrl, beerParsed)

		# Edit a beer (same as update)
		# @param [Beer Object] beer
		factory.edit = (beer) ->
			@update(beer)
		
		# Add a new beer
		# @param [Beer Object] beer
		factory.add = (beer) ->
			beer = parseBeerPostObject(beer)

			requestUrl = "/#{endpoint}"

			return mbRequest.post(requestUrl, beer)

		factory.delete = (id) ->
			requestUrl = "/#{endpoint}/#{id}"
			return mbRequest.delete(requestUrl)
		
		return factory			
])

# Recreate the recipe object
# to make sure that we are not posting unwanted stuff
# @param [Beer Object] beer
# @return [Object] postRecipe A beer object readied for post/put
parseBeerPostObject = (beer) ->
	console.log 'BEER HAS BREWERIES?'
	console.log beer.breweries
	postRecipe = {
		name: beer.name
		beerStyle: beer.beerStyle
		brewers: beer.brewers
		breweries: beer.breweries
		recipe: {
			brewers: beer.brewers
			breweries: beer.breweries
			volume: beer.recipe.volume
			efficiency: beer.recipe.efficiency
			og: beer.recipe.og
			fg: beer.recipe.fg
			mashSteps: []
			sparge: beer.recipe.sparge
			boilSteps: []
			fermentationSteps: []
		}
	}

	postRecipe.forkOf = beer.forkOf.id if beer.forkOf?

	i = 0
	for step in beer.recipe.mashSteps
		postRecipe.recipe.mashSteps.push({
			stepNumber: step.stepNumber
			temperature: step.temperature
			type: step.type
			length: step.length
			volume: step.volume
			notes: step.notes
			fermentables: []
			hops: []
			others: []
			yeasts: []
		})
		if step.fermentables
			for ingredient in step.fermentables
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.mashSteps[i].fermentables.push ingredient
		if step.hops
			for ingredient in step.hops
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.mashSteps[i].hops.push ingredient
		if step.others
			for ingredient in step.others
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.mashSteps[i].others.push ingredient
		if step.yeasts
			for ingredient in step.yeasts
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.mashSteps[i].yeasts.push ingredient
		i++
	i = 0
	for step in beer.recipe.boilSteps
		postRecipe.recipe.boilSteps.push({
			stepNumber: step.stepNumber
			length: step.length
			volume: step.volume
			notes: step.notes
			fermentables: []
			hops: []
			others: []
			yeasts: []
		})
		if step.fermentables
			for ingredient in step.fermentables
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.boilSteps[i].fermentables.push ingredient
		if step.hops
			for ingredient in step.hops
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.boilSteps[i].hops.push ingredient
		if step.others
			for ingredient in step.others
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.boilSteps[i].others.push ingredient
		if step.yeasts
			for ingredient in step.yeasts
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.boilSteps[i].yeasts.push ingredient
		i++
	i = 0 
	for step in beer.recipe.fermentationSteps
		postRecipe.recipe.fermentationSteps.push({
			stepNumber: step.stepNumber
			length: step.length
			volume: step.volume
			temperature: step.temperature
			notes: step.notes
			fermentables: []
			hops: []
			others: []
			yeasts: []
		})
		if step.fermentables
			for ingredient in step.fermentables
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.fermentationSteps[i].fermentables.push ingredient
		if step.hops
			for ingredient in step.hops
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.fermentationSteps[i].hops.push ingredient
		if step.others
			for ingredient in step.others
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.fermentationSteps[i].others.push ingredient

		if step.yeasts
			for ingredient in step.yeasts
				delete ingredient['$$hashKey'] 
				postRecipe.recipe.fermentationSteps[i].yeasts.push ingredient
		i++

	return postRecipe
