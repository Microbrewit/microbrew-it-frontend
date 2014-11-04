# Directive for calculating stuff
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Calculation')
	.directive('mbConvert', ['convert', (convert) ->
		return {
			restrict: 'E'
			scope: {
				'localunit': '@localunit'
				'modelvalue': '=modelvalue'
			}
			replace: false
			template: '<span><div><input type="text" ng-model="localvalue"/><select style="width:auto;display: inline-block;" ng-model="localunit" ng-options="value for value in conversions"></select></div></span>'
			link: (scope, element, attrs) ->

				# Get available conversion options (based on available formulas in convert)
				available = convert.available(attrs.modelunit)
				available.unshift attrs.modelunit
				scope.conversions = available

				updateLocalValue = ->
					scope.localvalue = +(convert.convert(scope.modelvalue, attrs.modelunit, scope.localunit)).toFixed(2)

				updateModelValue = ->
					scope.modelvalue = convert.convert(scope.localvalue, scope.localunit, attrs.modelunit)

				updateLocalValue()
				updateModelValue()

				# # modelunit will never change (it will always be the same as the server)
				scope.$watch(->
					return [scope.localunit, attrs.modelvalue]
				, updateLocalValue, true) 

				scope.$watch(->
					return [scope.localvalue]
				, updateModelValue, true)
		}
	])