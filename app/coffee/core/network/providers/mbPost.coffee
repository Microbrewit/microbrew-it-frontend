# API SET methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.factory('mbPost', ['$http', '$rootScope', '$log', 'ApiUrl', 'ClientUrl', 'localStorage', 'notification', ($http, $rootScope, $log, ApiUrl, ClientUrl, localStorage, notification) ->
		factory = {}
		factory.set = (requestUrl, object) ->
			requestUrl = "#{ApiUrl}#{requestUrl}"
			#auth = localStorage.getItem('user')
			console.log 'factory.set'
			promise = false
			request = 
				async: () ->

					# Need logic for ad-hoc login

					unless promise
						$rootScope.loading++

						promise = $http.post(
							requestUrl, 
							object,
							{
								withCredentials: true
								headers: {
									"Authorization": "Bearer #{$rootScope.token.token}"
								}
							}
						)
							.error((data, status) ->
								$rootScope.loading--
								console.log data

								for key, value of data.ModelState
									title = 'Error: ' + value[0]
									body = value[1]

								status = status + ""

								title = "Error" unless title
								title += " (HTTP #{status})" unless status[0] is '4'
								body = "Could not save data." unless body
								body = "We are experiencing server issues. Try again later." if status[0] is '5'

								notification.add
									title: title # required
									body: body # optional
									type: 'error'
									#icon: 'url/to/icon' # optional
									#onClick: callback # optional
									#onClose: callback # optional
									time: 50000 # default: null, ms until autoclose
									#medium: 'native' # default: null, native = browser Notification API
							)
							.then((response) ->

								notification.add
									title: 'Saved'
									body: 'Successfully saved to cloud'
									type: 'success'
									time: 5000
									
								token = 
									expires: new Date(response.headers('.expires')).getTime()
									token: response.headers('access_token')
									refresh: response.headers('refresh_token')

								# Save new auth token
								$rootScope.token = token
								localStorage.setItem('token', token)

								$rootScope.loading--
								return response.data
							)
					
					return promise
			
			return request
		factory.fermentables = (id = null) ->
			###fermentable:
				id: 123
				supplier:
					id: 432
					name: 'Some Supplier'
				name: 'String'
				ppg: 123
				type: 'Grain'###
		factory.hops = (id = null) ->
		factory.yeasts = (id = null) ->

		factory.recipe = (beer) ->

			# Recreate the recipe object
			# to make sure that we are not posting unwated stuff
			postRecipe = {
				name: beer.name
				brewers: [
					{
						username: $rootScope.user.userId
					}
				],
				beerStyle: beer.beerStyle
				recipe: {
					volume: beer.recipe.volume
					efficiency: beer.recipe.efficiency
					og: beer.recipe.og
					fg: beer.recipe.fg
					mashSteps: []
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

			console.log JSON.stringify postRecipe, null, '\t'

			return @set("/beers", postRecipe)

		return factory

	])