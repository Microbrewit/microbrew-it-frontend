# API SET methods 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Network')
	.factory('mbSet', ['$http', '$log', 'ApiUrl', 'localStorage', ($http, $log, ApiUrl, localStorage) ->
		factory = {}
		factory.set = (requestUrl, object) ->
			auth = localStorage.getItem('user')
			request = 
				async: () ->
					# if not $scope.token.token
					# 	user = localStorage.getItem('user')
					# 	if user and user.auth isnt ""


					unless promise
						$log.debug 'ASYNC SET fermentable'
						$rootScope.loading++

						promise = $http.post(
							requestUrl, 
							object,
							{
								withCredentials: true
								headers: {
									'authorization-token': $scope.token.token
								}
							}
						)
							.error((data, status) ->
								$rootScope.loading--
								$log.error(data)
								$log.error(status)
							)
							.then((response) ->
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

		return factory

	])