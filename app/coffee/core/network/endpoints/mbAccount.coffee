# Wrapper for Account endpoint
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Network')
.factory('mbAccount', [
	'mbGet'
	'mbPost'
	'mbPut'
	'mbRequest'
	'notification'
	(mbGet, mbPost, mbPut, mbRequest, notification) ->
		factory =
			register: register
			resend: resend
			forgot: forgot
			reset: reset
			update: update
])

# Relative endpoint url
endpoint = 'Account'

# Register a new user
# @param [Object] userObj
# @option userObj [string] username (required)
# @option userObj [string] email (required)
# @option userObj [array] brewery
# @option userObj [object] settings
# @option userObj [string] password (required)
# @option userObj [string] confirmPassword (required)
# @option userObj [object] geoLocation
register = (userObj) ->
	if userObj.username? and userObj.email? and userObj.password? and userObj.confirmPassword?
		mbRequest.post("/#{endpoint}/Register", userObj)
	else
		console.log 'error'

# Resend email verification
# @param [String] username
resend = (username) ->
	mbRequest.get("/#{endpoint}/resend", {username: username})

# Forgot password
# @param [string] email
forgot = (email) ->
	mbRequest.post("/#{endpoint}/forgot", {Email: email})

# Reset password

reset = () ->

# Update Account
# @param [Object] userObj
# @option userObj [string] username (required)
# @option userObj [string] email (required)
# @option userObj [array] brewery
# @option userObj [object] settings
# @option userObj [string] password (required)
# @option userObj [string] confirmPassword (required)
# @option userObj [object] geoLocation
update = (userObj) ->
