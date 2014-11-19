# Module for messages/notification to user.
# Supports both native notifications (through the browser Notification API) and local notifications displayed within the browser.
#
# The module consists of one factory, notification, which essentially wraps around an array of messages.
# notification.add(message) pushes notifications to the array
# notification.close(index) removes the given message
# notification.messages is the messages array
#
# @method add
# @method close
# @method getMessages

# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Notifications', [])