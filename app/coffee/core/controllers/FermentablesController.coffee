mbit = angular.module('Microbrewit')

mbit.controller('IngredientController', ['$scope', 'mbGet', 'mbDelete', 'mbPut', '$stateParams', '_', '$state', '$rootScope',
	($scope, get, mbDelete, mbPut, $stateParams, _, $state, $rootScope) ->

		setControllerState = (event, toState, toParams, fromState, fromParams) ->

			currentState = toState?.name 
			currentState ?= $state?.current?.name

			stateArr = currentState.split('.')

			if toParams?
				params = toParams
			else
				params = $state.params

			console.log 'params'
			console.log params

			# Looking at fermentables
			if 'fermentables' in stateArr
				console.log 'fermentables'
				# We are doing something with a single hop
				if params.id
					console.log "ID: #{params.id}"
					get.fermentables(params.id).then((apiResponse) -> 
						$scope.fermentable = apiResponse.fermentables[0]
					)
				else
					get.fermentables().then((apiResponse) -> 
						$scope.fermentables = _.sortBy(apiResponse.fermentables, (ingredient) -> return ingredient.name)
						console.log 'fucking apply'
						$scope.$digest()
					)
				
				# Editing Hop
				if currentState is 'fermentables.edit'
					$scope.update = () ->
						mbPut.fermentables($scope.fermentables).then()

					$scope.delete = () ->
						mbDelete.fermentables($scope.fermentables).then()

			# Looking at yeasts
			if 'yeasts' in stateArr
				console.log 'yeasts'
				# We are doing something with a single hop
				if params.id
					get.yeasts(params.id).then((apiResponse) -> 
						$scope.yeast = apiResponse.yeasts[0]
					)
				else
					get.yeasts().then((apiResponse) -> 
						$scope.yeasts = _.sortBy(apiResponse.yeasts, (ingredient) -> return ingredient.name)
						console.log 'fucking apply'
						$scope.$digest()
					)
				
				# Editing Hop
				if currentState is 'yeasts.edit'
					$scope.update = () ->
						mbPut.yeasts($scope.yeasts).then()

					$scope.delete = () ->
						mbDelete.yeasts($scope.yeasts).then()

			# Looking at hops
			if 'hops' in stateArr
				console.log 'hops'
				# We are doing something with a single hop
				if params.id
					get.hops(params.id).then((apiResponse) -> 
						$scope.hop = apiResponse.hops[0]
					)
				else
					get.hops().then((apiResponse) -> 
						$scope.hops = _.sortBy(apiResponse.hops, (ingredient) -> return ingredient.name)
						console.log 'fucking apply'
						$scope.$digest()
					)
				
				# Editing Hop
				if currentState is 'hops.edit'
					$scope.update = () ->
						mbPut.hops($scope.hops).async().then()

					$scope.delete = () ->
						mbDelete.hops($scope.hops).async().then()

		$scope.$on('$stateChangeStart', setControllerState)
		setControllerState()
		
])