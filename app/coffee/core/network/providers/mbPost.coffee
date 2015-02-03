# API SET methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.factory('mbSet', ['$http', '$rootScope', '$log', 'ApiUrl', 'ClientUrl', 'localStorage', ($http, $rootScope, $log, ApiUrl, ClientUrl, localStorage) ->
		factory = {}
		factory.set = (requestUrl, object) ->
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
								$log.error(data)
								$log.error(status)
								console.error(status)
								console.error(data)
							)
							.then((response) ->
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

		factory.recipe = (recipe) ->

			# Recreate the recipe object
			# to make sure that we are not posting unwated stuff
			postRecipe = {
				name: recipe.name
				brewers: [
					{
						username: $rootScope.user.userId
					}
				],
				beerStyle: {
					name: recipe.beerStyle.name
					id: recipe.beerStyle.beerStyleId
				}
				recipe: {
					volume: recipe.volume
					efficiency: recipe.efficiency
					fg: recipe.fg
					mashSteps: []
					boilSteps: []
					fermentationSteps: []
				}
			}

			i = 0
			for step in recipe.mashSteps
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
			for step in recipe.boilSteps
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
			for step in recipe.fermentationSteps
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

			return @set("#{ApiUrl}/beers", postRecipe)

		return factory

	])