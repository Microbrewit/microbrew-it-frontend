mbit = angular.module('Microbrewit')

mbit.controller('IngredientController', ['$scope', 'mbFermentable', 'mbHop', 'mbYeast', '_', '$state',
	($scope, mbFermentable, mbHop, mbYeast, _, $state) ->

		setControllerState = (event, toState, toParams, fromState, fromParams) ->

			currentState = toState?.name 
			currentState ?= $state?.current?.name

			stateArr = currentState.split('.')

			if toParams?
				params = toParams
			else
				params = $state.params

			# Looking at fermentables
			if 'fermentables' in stateArr
				# We are doing something with a single hop
				if params.id
					mbFermentable.get(params.id).then((apiResponse) -> 
						$scope.fermentable = apiResponse[0]
					)
				else
					mbFermentable.get().then((apiResponse) -> 
						$scope.results = _.sortBy(apiResponse, (ingredient) -> return ingredient.name)
						$scope.$digest()
					)

				if currentState is 'fermentables.edit'
					$scope.update = () ->
						mbFermentable.update($scope.fermentable).then()

					$scope.delete = () ->
						mbFermentable.delete($scope.fermentable).then()

			# Looking at yeasts
			if 'yeasts' in stateArr
				# We are doing something with a single hop
				if params.id
					mbYeast.get(params.id).then((apiResponse) -> 
						$scope.yeast = apiResponse[0]
					)
				else
					mbYeast.get().then((apiResponse) -> 
						$scope.results = _.sortBy(apiResponse, (ingredient) -> return ingredient.name)
						console.log 'fucking apply'
						$scope.$digest()
					)
				
				# Editing Hop
				if currentState is 'yeasts.edit'
					$scope.update = () ->
						mbYeast.update($scope.yeast).then()

					$scope.delete = () ->
						mbYeast.delete($scope.yeast).then()

			# Looking at hops
			if 'hops' in stateArr
				# We are doing something with a single hop
				if params.id
					mbHop.get(params.id).then((apiResponse) -> 
						$scope.hop = apiResponse[0]
					)
				else
					mbHop.get().then((apiResponse) -> 
						$scope.results = _.sortBy(apiResponse, (ingredient) -> return ingredient.name)
						console.log 'fucking apply'
						$scope.$digest()
					)
				
				# Editing Hop
				if currentState is 'hops.edit'
					$scope.update = () ->
						mbHop.update($scope.hop).then()

					$scope.delete = () ->
						mbHop.delete($scope.hop).then()

		$scope.$on('$stateChangeStart', setControllerState)
		setControllerState()
		
])