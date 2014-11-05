# API SET methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.factory('mbSet', ['$http', '$rootScope', '$log', 'ApiUrl', 'localStorage', ($http, $rootScope, $log, ApiUrl, localStorage) ->
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
							{
								"Name": "Test Beer",
								"Brewers": [
									{
										"Username": "torstein",
										"email": "torstein@gmail.no"
									}
								],
								"BeerStyle": {
									"Id": 122,
									"Name": "Belgian-Style Dubbel"
								},
								"Recipe": {
									"Volume":30, 
									"Efficiency":80,
									"FG":1.015,
									"MashSteps": [
										{
											"Temperature": 68,
											"Type": "Infusion",
											"Length": 60,
											"Volume": 30,
											"Fermentables": [
												{
													"FermentableId": 6,
													"Amount": 5000,
													"Lovibond": 10
												},
												{
													"FermentableId": 7,
													"Amount": 1000,
													"Lovibond": 10
												},
												{
													"FermentableId": 8,
													"Amount": 500,
													"Lovibond": 10
												},
												{
													"FermentableId": 9,
													"Amount": 500,
													"Lovibond": 10
												}
											]
										}
									],
									"BoilSteps": [
										{
											"Number": 1,
											"Length": 60,
											"Volume": 30,
											"Hops": [
												{
													"HopId": 4,
													"AAValue": 10,
													"Amount": 15,
													"HopForm": {
														"Id":1,
														"Name": "Pellet"
													}
												}
											]
										},
										{
											"Number": 2,
											"Length": 15,
											"Volume": 30,
											"Hops": [
												{
													"HopId": 7,
													"AAValue": 5.9,
													"Amount": 35,
													"HopForm":{
														"Id":1,
														"Name": "Pellet"
													}
												}
											]
										},
										{
											"Number": 3,
											"Length": 5,
											"Volume": 30,
											"Hops": [
												{
													"HopId": 7,
													"AAValue": 5.9,
													"Amount": 35,
													"HopForm":{
														"Id":1,
														"Name": "Pellet"
													}
												}
											]
										}
									],
									"FermentationSteps": [
										{
											"Number": 1,
											"Length": 14,
											"Temperature": 19,
											"Notes": "Do Something Cool",
											"Yeasts": [
												{
													"YeastId": 1,
													"Amount": 1
												}
											],
											"Others": [
												{
													"OtherId": 1,
													"Amount": 12
												}
											]
										}
									]
								}
							},
							{
								withCredentials: true
								headers: {
									'authorization-token': $rootScope.token.token
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
								# Save new auth token
								authToken = response.headers('authorization-token')
								if authToken?
									$rootScope.token =
										expires: new Date()
										token: authToken

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
						username: $rootScope.user.username
					}
				],
				beerStyle: recipe.beerStyle,
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
					number: step.number
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
					number: step.number
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