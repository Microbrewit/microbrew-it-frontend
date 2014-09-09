# Module for using native browser notifications
# Based on MDN Notification api example
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/utils/NotificationService', []).
	factory('messages', () ->
		notification = {}

		notification.messages = []

		# Message contains: title, body, type, onclick, onshow, onclose, icon
		notification.add = (message, time=null) ->
			console.log message
			index = @messages.push message

			# Autoclose message if time is specified
			if time
				setTimeout(=>
					@close(index)
				, time)

			return index

		# Close given index
		notification.close = (index) ->
			@messages.splice(index, 1)

		# Get all messages
		notification.getMessages = () ->
			return @messages

		return notification

	).
	# Urgent message tries to get the message/notification to the user as fast as possible,
	# either through the native browser Notification api, or through Microbrew.it messages
	service('urgentMessage', (messages, notification) ->
		returnFunc = (message, time=null) ->
			if document.hasFocus()
				messages.add(message, time)
			else
				notification(message, time)
	).
	# Message contains: title, body, type, callback
	service('notification', (messages) ->
		notification = (message, time=3000) ->
			notificationOptions = message

			# Let's check if the browser supports notifications
			if not 'Notification' in window
				console.warn 'Notification API not supported in this browser'

				# Fallback to normal messages
				messages.add(message, time)

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

			if notification and time
				setTimeout(->
					notification.close()
				, time)
	)
	