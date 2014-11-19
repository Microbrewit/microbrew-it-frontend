angular.module('Microbrewit/core/User')
	.service('updateUser', ['ApiUrl', 'mbSet', (ApiUrl, mbSet) ->
		userUpdate = (userObject) ->
			# TODO: Check user object for errors
			return mbSet.set("#{ApiUrl}/users", userObject)
	])