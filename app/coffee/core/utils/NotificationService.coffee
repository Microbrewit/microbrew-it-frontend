# Module for using native browser notifications
# Based on MDN Notification api example
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/utils/NotificationService', []).
	factory('notification', ['$rootScope', ($rootScope) ->

		nativeNotification = (message) ->
			notificationOptions = message

			# Let's check if the browser supports notifications
			if not 'Notification' in window
				console.warn 'Notification API not supported in this browser'

			# Let's check if the user is okay to get some notification
			else if Notification.permission is 'granted'
				# If it's okay let's create a notification
				notification = new Notification message.title, notificationOptions

			# Otherwise, we need to ask the user for permission
			# Note, Chrome does not implement the permission static property
			# So we have to check for NOT 'denied' instead of 'default'
			else if Notification.permission isnt 'denied'
				Notification.requestPermission((permission) ->
					# Whatever the user answers, we make sure we store the information
					if not 'permission' in Notification
						Notification.permission = permission
					
					# If the user is okay, let's create a notification
					if permission is 'granted'
						notification = new Notification message.title, notificationOptions
				)

			if notification and message.time
				setTimeout(->
					notification.close()
				, message.time)
		

		notification = {}
		notification.messages = []

		# Message contains: title, body, type, onclick, onshow, onclose, icon
		notification.add = (message) ->
			console.log message

			if message.medium? and message.medium is 'native'
				nativeNotification(message)
			else
				@messages.push message

				$rootScope.$apply() unless $rootScope.$$phase #manually digest scope

				# Autoclose message if time is specified
				if message.time
					setTimeout(=>
						@close(@messages.indexOf(message), true)
						$rootScope.$apply() unless $rootScope.$$phase # manually digest scope
					, message.time)

		# Close given index
		notification.close = (index) ->
			@messages.splice(index, 1)

		# Get all messages
		notification.getMessages = () ->
			console.log @messages
			return @messages

		return notification

	])
	