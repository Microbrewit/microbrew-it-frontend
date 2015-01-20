# API SET methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.factory('mbPut', ['$http', '$rootScope', '$log', 'ApiUrl', 'ClientUrl', 'localStorage', ($http, $rootScope, $log, ApiUrl, ClientUrl, localStorage) ->
		factory = {}
		factory.set = (requestUrl, object) ->
			#auth = localStorage.getItem('user')
			console.log 'mbPut'
			console.log 'factory.set'
			promise = false
			request = 
				async: () ->

					# Need logic for ad-hoc login

					unless promise
						$rootScope.loading++

						promise = $http.put(
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
		
		factory.yeasts = (yeast) ->
			yeastPut = {
				yeastId: yeast.yeastId,
				name: yeast.name,
				temperatureHigh: yeast.temperatureHigh,
				temperatureLow: yeast.temperatureLow,
				flocculation: yeast.flocculation,
				alcoholTolerance: yeast.alcoholTolerance,
				productCode: yeast.productCode,
				notes: yeast.notes,
				type: yeast.type,
				brewerySource: yeast.brewerySource,
				species: yeast.species,
				attenutionRange: yeast.attenutionRange,
				pitchingFermentationNotes: yeast.pitchingFermentationNotes,
				supplier: yeast.supplier,
				dataType: "yeast",
				custom: yeast.custom,

			}
			return @set("#{ApiUrl}/yeasts/" + yeast.yeastId, yeastPut)

		return factory
		
	])