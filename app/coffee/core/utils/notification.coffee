notifyMe() ->
	# Let's check if the browser supports notifications
	if !("Notification" in window) 
		console.warn 'Notification API not supported in this browser'
		# Need fallback

	# Let's check if the user is okay to get some notification
	else if Notification.permission is "granted"
		# If it's okay let's create a notification
		notification = new Notification "Hi there!"

	# Otherwise, we need to ask the user for permission
	# Note, Chrome does not implement the permission static property
	# So we have to check for NOT 'denied' instead of 'default'
	else if Notification.permission isnt 'denied'
		Notification.requestPermission((permission) ->
			# Whatever the user answers, we make sure we store the information
			if !('permission' in Notification)
				Notification.permission = permission
			

			# If the user is okay, let's create a notification
			if permission is "granted"
				notification = new Notification "Hi there!"
		)