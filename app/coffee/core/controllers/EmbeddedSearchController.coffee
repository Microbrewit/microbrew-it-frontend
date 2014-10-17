mbit = angular.module('Microbrewit')

mbit.controller('EmbeddedSearchController', ['$scope', 'mbSearch', 'mbGet', 'filterFilter',
	($scope, search, get, filterFilter) ->

		$scope.addFermentableToStep = (step, fermentable) ->
			step.fermentables.push(fermentable)
			close()
		$scope.addHopsToStep = (step, hop) ->
			step.hops.push(hop)
			close()
		$scope.addYeastToStep = (step) ->
			step.yeasts.push({ name: "lol" })

		close = () ->
			$scope.searchContext.active = false

		$scope.$watch('searchContext', (newVal, oldVal) ->
			$scope.query = ''
			if newVal.endpoint isnt oldVal.endpoint
				if newVal.endpoint is 'fermentables'
					get.fermentables().async().then((apiResponse) ->
						$scope.results = apiResponse.fermentables
					)
				else if newVal.endpoint is 'hops'
					get.hops().async().then((apiResponse) ->
						$scope.results = apiResponse.hops
					)
		, true)    
])