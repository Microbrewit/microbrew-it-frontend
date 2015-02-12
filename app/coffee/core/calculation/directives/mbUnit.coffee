# Directive for displaying things in correct units.
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Calculation')
	.directive('mbUnit', ['convert', (convert) ->
		return {
			restrict: 'E'
			scope: {
				'localunit': '@localunit'
				'modelvalue': '=modelvalue'
			}
			replace: false
			template: '<span><div><span style="font-size: 16px;font-weight: bold;" ng-show="!editable">{{localvalue}}</span> {{localunit}}</div></span>'
			link: (scope, element, attrs) ->

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