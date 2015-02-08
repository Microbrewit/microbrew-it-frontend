# LocalStorage and SessionStorage Directive
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Utils')
	.service('validJSON', () ->
		tryParseJSON = (jsonString) ->
			try 
				o = JSON.parse(jsonString)

				# Handle non-exception-throwing cases:
				# Neither JSON.parse(false) or JSON.parse(1234) throw errors, hence the type-checking,
				# but... JSON.parse(null) returns 'null', and typeof null === "object", 
				# so we must check for that, too.
				if o and typeof o is "object" and o isnt null
					return o
			catch e
				return false

			return false
	)
	.factory('localStorage', (validJSON) ->
		storageApi = {}

		storageApi.getItem = (key) ->
			value = window.localStorage.getItem key

			# validJSON returns parsed JSON if it is valid, false if not
			json = validJSON value

			# was it valid JSON
			if json and typeof json is "object"
				return json
			else
				return value

		storageApi.setItem = (key, value) ->
			# Since we can only store strings, we need to stringify objects
			if typeof value is "object"
				value = JSON.stringify value

			window.localStorage.setItem(key, value)

		storageApi.removeItem = (key) ->
			window.localStorage.removeItem(key)

		return storageApi
	)
	.factory('sessionStorage', (validJSON) ->
		storageApi = {}

		
		storageApi.getItem = (key) ->
			value = window.sessionStorage.getItem key

			# validJSON returns parsed JSON if it is valid, false if not
			json = validJSON value

			# was it valid JSON
			if json and typeof json is "object"
				return json
			else
				return value

		storageApi.setItem = (key, value) ->
			# Since we can only store strings, we need to stringify objects
			if typeof value is "object"
				value = JSON.stringify value

			window.sessionStorage.setItem key, value

		storageApi.removeItem = (key) ->
			window.localStorage.removeItem(key)

		return storageApi
	)