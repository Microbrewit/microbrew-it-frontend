# Configure Microbrew.it application (import modules + configure router)
# @author Torstein Thune
# @copyright 2014 Microbrew.it

app = angular.module('Microbrewit', [])

# app.config(
# 	['$routeProvider'], 
# 	($routeProvider) ->
# 		$routeProvider.when('/', 
# 			templateUrl: 'templates/home.html'
# 			controller: 'HomeCtrl'
# 		).
# 		otherwise(
# 			redirectTo: '/'
# 		)
# )