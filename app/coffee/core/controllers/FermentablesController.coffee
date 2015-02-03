mbit = angular.module('Microbrewit')

mbit.controller('IngredientController', ['$scope', 'mbGet', '$stateParams', '_', '$state',
	($scope, get, $stateParams, _, $state) ->
		
		if $state.includes('fermentables')
			# We are displaying information about a single hop
			if $stateParams.id
				get.fermentables($stateParams.id).then((apiResponse) ->
					$scope.fermentable = apiResponse.fermentables[0]
				)
			# We are displaying all hops
			else
				get.fermentables().then((apiResponse) ->
					$scope.fermentables = _.sortBy(apiResponse.fermentables, (ingredient) -> return ingredient.name)
				)
		if $state.includes('hops')
			# We are displaying information about a single hop
			if $stateParams.id
				get.hops($stateParams.id).then((apiResponse) ->
					$scope.hop = apiResponse.hops[0]
				)
			# We are displaying all hops
			else
				get.hops().then((apiResponse) ->
					$scope.hops = _.sortBy(apiResponse.hops, (ingredient) -> return ingredient.name)
				)
		if $state.includes('yeasts')
			# We are displaying information about a single hop
			if $stateParams.id
				get.yeasts($stateParams.id).then((apiResponse) ->
					$scope.yeast = apiResponse.yeasts[0]
				)
			# We are displaying all hops
			else
				get.yeasts().then((apiResponse) ->
					$scope.yeasts = _.sortBy(apiResponse.yeasts, (ingredient) -> return ingredient.name)
				)
])