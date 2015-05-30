mbit = angular.module('Microbrewit')

mbit.controller('RecipeController', [
	'$rootScope'
	'$scope'
	'mbGet'
	'mbFermentable'
	'mbHop'
	'mbYeast'
	'localStorage'
	'sessionStorage'
	'$stateParams'
	'_'
	'colour'
	'$state'
	'mbUser'
	'mbBeer'
	($rootScope, $scope, mbGet, mbFermentable, mbHop, mbYeast, localStorage, sessionStorage, $stateParams, _, colourCalc, $state, mbUser, mbBeer) ->
		$scope.hopTypes = []
		$scope.spargeTypes = ['fly sparge', 'batch sparge']

		# There must be a better way
		updateStepNumbers = () ->
			for i in [0...$scope.beer.recipe.mashSteps.length]
				$scope.beer.recipe.mashSteps[i].stepNumber = i+1

			$scope.beer.recipe.spargeStep.stepNumber = $scope.beer.recipe.mashSteps.length + 1

			for i in [0...$scope.beer.recipe.boilSteps.length]
				$scope.beer.recipe.boilSteps[i].stepNumber = $scope.beer.recipe.mashSteps.length+i+2
			for i in [0...$scope.beer.recipe.fermentationSteps.length]
				$scope.beer.recipe.fermentationSteps[i].stepNumber = $scope.beer.recipe.mashSteps.length+$scope.beer.recipe.boilSteps.length+i+2

		# Get ingredients, beerstyles, etc.
		mbGet.hopForms().then((response) ->
			$scope.hopForms = response
			$scope.hopTypes = response
		)
		mbFermentable.get().then((response) ->
			$scope.fermentables = response
			$scope.groupFermentables = (fermentable)->
				return fermentable.type
		)

		mbHop.get().then((response) ->
			for hop in response
				hop.aaValue = hop.aaLow
				if hop.aaHigh isnt 0
					hop.aaValue = (hop.aaValue + hop.aaLow) / 2
				hop.betaValue = hop.betaLow
				if hop.betaHigh isnt 0
					hop.betaValue = (hop.betaValue+ hop.aaLow) / 2
				hop.hopForm = $scope.hopForms[0]

			$scope.hops = response
			$scope.groupHops = (hops)->
				return hops.origin.name if hops.origin?.name?
				return 'other'
		)
		mbYeast.get().then((response) ->
			$scope.yeasts = response
			$scope.groupYeasts = (yeast)->
				return yeast.supplier.name if yeast.supplier?.name?
				return 'Other'
		)

		# ---- Common Scope functions ----
		$scope.addMashStep = () ->
			volume = parseInt($scope.beer.recipe.mashSteps?[$scope.beer.recipe.mashSteps?.length-1]?.volume,10)
			volume or= parseInt($scope.beer.recipe.volume*0.66, 10)

			temperature = parseInt($scope.beer.recipe.mashSteps?[$scope.beer.recipe.mashSteps?.length-1]?.temperature,10)
			temperature or= 65

			type = $scope.beer.recipe.mashSteps?[$scope.beer.recipe.mashSteps?.length-1]?.type
			type or= "infusion"

			$scope.beer.recipe.mashSteps.push
				stepNumber: 0
				type: type
				length: 60
				volume: volume
				temperature: temperature
				stepType: "mashSteps"
				fermentables: []
				hops: []
				others: []
				yeasts: []
				notes: ""

			updateStepNumbers()


		$scope.addBoilStep = () ->

			$scope.beer.recipe.boilSteps.push
				stepNumber: 0
				length: 60
				volume: 20
				stepType: "boilSteps"
				fermentables: []
				hops: []
				others: []
				yeasts: []
				notes: ""

			updateStepNumbers()


		$scope.addFermentationStep = () ->
			$scope.beer.recipe.fermentationSteps.push
				stepNumber: 0
				stepType: "fermentationSteps"
				type: 'primary fermentation'
				length: 14
				temperature: 24
				fermentables: []
				hops: []
				others: []
				yeasts: []
				notes: ""

			updateStepNumbers()

		window.log = () ->
			console.log $scope

		setControllerState = (event, toState, toParams, fromState, fromParams) ->
			console.log 'RecipeController.setControllerState'
			$scope.beer = false

			currentState = toState?.name 
			currentState ?= $state?.current?.name

			currentParams = toParams
			currentState ?= $state.params

			if currentState isnt 'edit'
				$scope.submitRecipe = () ->
					if not $scope.token?
						# we need username and password
						mbUser.login($scope.username,$scope.password,false).then(
							$scope.beer.brewers.push $scope.user
							mbBeer.add($scope.beer).then((response) ->
								$state.go('brews.single({id:response.beer.id})')
							)
						)

					else if $scope.token?.expires <= new Date().getTime()
						# We need to refresh token
						mbUser.login(false,false,$scope.token).then(
							$scope.beer.brewers.push $scope.user
							mbBeer.add($scope.beer).then((response) ->
								$state.go('brews.single({id:response.beer.id})')
							)
						)
					else
						$scope.beer.brewers.push $scope.user
						mbBeer.add($scope.beer).then((response) ->
							$state.go('brews.single({id:response.beer.id})')
						)

			if currentState is 'fork' or currentState is 'edit'

				mbBeer.getSingle($stateParams.id).then((response) ->
					$scope.beer = JSON.parse(JSON.stringify(response.beers[0]))

					# We need to keep track of the original ingredient in order for the select directive to work
					# So we need to do some dirty work
					for step in $scope.beer.recipe.mashSteps
						for ingredient in step.fermentables
							ingredient.original = _.clone ingredient
						for ingredient in step.hops
							ingredient.original = _.clone ingredient
						for ingredient in step.others
							ingredient.original = _.clone ingredient

					for step in $scope.beer.recipe.boilSteps
						for ingredient in step.fermentables
							ingredient.original = _.clone ingredient
						for ingredient in step.hops
							ingredient.original = _.clone ingredient
						for ingredient in step.others
							ingredient.original = _.clone ingredient

					for step in $scope.beer.recipe.fermentationSteps
						for ingredient in step.fermentables
							ingredient.original = _.clone ingredient
						for ingredient in step.hops
							ingredient.original = _.clone ingredient
						for ingredient in step.others
							ingredient.original = _.clone ingredient
						for ingredient in step.yeasts
							ingredient.original = _.clone ingredient

					
					if currentState is 'fork'
						# This is a fork
						$scope.beer.forkOf = 
							id: $scope.beer.id
							name: $scope.beer.name

						# Edit name and remove id since it is a fork
						$scope.beer.name += ' fork'
						$scope.beer.id = undefined

					else if currentState is 'edit'
						$scope.submitRecipe = () ->
							mbBeer.update($scope.beer).then(() ->
								$state.go('brews.single({id:$scope.beer.id})')
							)
					
					mbGet.beerstyles().then((response) -> $scope.beerStyles = response.beerStyles)
				)

			else
				console.log 'SET DEFAULT RECIPE VALUES'
				$scope.beer = 
					name: ''
					mcu: 0
					abv:
						standard: 0
						miller: 0
						advanced: 0
						advancedAlternative: 0
						simple: 0
						alternativeSimple: 0
					ibu:
						standard: 0
						tinseth: 0
						rager: 0
					srm: 
						standard: 0
						mosher: 0
						daniels: 0
						morey: 0
					beerStyle: 
						id: 0
						name: ''
					forkOf: null
					breweries: []
					brewers: []

					recipe:
						notes: ''
						og: 0
						fg: 0
						efficiency: 70
						volume: 30
						dataType: 'recipe'
						mashSteps: []

						spargeStep: {
							stepNumber: 0
							amount: 5
							temperature: 78
							type: $scope.spargeTypes[0]
							notes: ''
						}

						boilSteps: []
						fermentationSteps: []
						priming: [
							{
								fermentables: []
								notes: ''
							}
						]
						notes: ""

				mbGet.beerstyles().then((response) ->

					$scope.beerStyles = response.beerStyles
					$scope.beer.beerStyle = $scope.beerStyles[0]

					$scope.groupBeerstyles = (style)->
						return style.superBeerStyle.name if style.superBeerStyle?.name?
						return style.name
				)

				# If adding to a brewery
				if $scope.brewery
					console.log 'HAS BREWERY IN SCOPE'
					$scope.beer.breweries.push _.cloneDeep $scope.brewery
					$scope.brewery = undefined

				$scope.addMashStep()
				$scope.addBoilStep()
				$scope.addFermentationStep()
		
			# get ingredients
			sessionId = "recipe-#{new Date().getTime()}"

		setControllerState()
		$scope.$on('$stateChangeStart', setControllerState)

		$scope.updateFermentableValues = () ->
			totalMCU = 0
			totalGP = 0

			relevantSteps = _.union $scope.beer.recipe.mashSteps, $scope.beer.recipe.boilSteps

			for step in relevantSteps
				for ingredient in step.fermentables
					totalGP+=parseFloat ingredient.gravityPoints
					totalMCU+=parseFloat ingredient.mcu

			# Gravity
			totalGP = parseInt(totalGP)
			$scope.beer.recipe.og = (1 + totalGP/1000).toFixed(3)
			$scope.beer.recipe.fg = (($scope.beer.recipe.og-1)*(1-0.75)+1).toFixed(3)

			# Colour
			$scope.beer.mcu = totalMCU
			$scope.beer.srm.standard = parseInt(1.4922 * Math.pow(totalMCU, 0.6859))

		$scope.updateHopsValues = () ->
			totalIBU = 0
			
			for step in $scope.beer.recipe.mashSteps
				for ingredient in step.hops
					totalIBU = totalIBU + parseFloat(ingredient.ibu) if ingredient.ibu and not isNaN(ingredient.ibu)

			for step in $scope.beer.recipe.boilSteps 
				for ingredient in step.hops
					totalIBU = totalIBU + parseFloat(ingredient.ibu) if ingredient.ibu and not isNaN(ingredient.ibu)

			console.log "total IBU: #{totalIBU}"
			$scope.beer.ibu.tinseth = parseInt(totalIBU, 10)

		$scope.removeStep = (step) ->
			index = $scope.beer.recipe[step.stepType].indexOf(step)
			$scope.beer.recipe[step.stepType].splice(index,1)
			updateStepNumbers()

		$scope.removeFromStep = (thing, thingArr) ->
			thingArr.splice(thingArr.indexOf(thing),1)
				
		$scope.change =() ->

		$scope.refreshIngredient = (ingredient, model) -> refreshIngredient(ingredient, model)

		$scope.addIngredientToStep = (step, ingredient) -> addIngredientToStep(step, ingredient, $scope)
])

# Filters an ingredients list by properties given.
# @param [Array] of ingringredients to be filtered.
# @param [Array] of parameters to filter the ingredients by.
mbit.filter 'propsFilter', -> 
	(ingredients, props) ->
		out = []
		if angular.isArray(ingredients)
			for ingredient in ingredients
	 			itemMatches = false

	 			keys = Object.keys(props)
	 			for key in keys
	 				text = props[key].toLowerCase()
	 				if ingredient[key].toString().toLowerCase().indexOf(text) isnt -1
	 					itemMatches = true
	 					break
	 			if itemMatches
	 				out.push(ingredient)
		else 
			out = ingredients
		return out


# Add an empty ingredient to a step
# @param [Object] step The step to add an ingredient to
# @param [String] ingredient The type of ingredient to add
addIngredientToStep = (step, ingredient, $scope) ->
	if ingredient is 'fermentable'
		step.fermentables.push
			amount: 0
			ppg: 0
			lovibond: 0

	else if ingredient is 'hop'
		step.hops.push
			aaValue: 0
			betaValue: 0
			amount: 0
			hopForm: $scope.hopTypes[0]	

	else if ingredient is 'yeast'
		ingredient = {}
		step.yeasts.push(ingredient)

# Refresh an ingredient when chosen in select
# This copies relevant parts from "original" property
# @param [Object] ingredient The ingredient to copy to
# @param [Object] model The model to copy from
refreshIngredient = (ingredient, model) ->
	allowedKeys = [
		'name'
		'fermentableId'
		'ppg'
		'lovibond'

		'hopId'
		'aaValue'
		'betaValue'
		'flavours'

		'yeastId'
		'temperatureHigh'
		'temperatureLow'
		'flocculation'
		'alcoholTolerance'
		'productCode'
		'notes'
		'type'
		'brewerySource'
		'species'
		'attenutionRange'
		'pitchingFermentationNotes'
		'supplier'
		'dataType'
	]
	for key,val of model
		if key in allowedKeys
			ingredient[key] = val

	unless ingredient.localId
		ingredient.localId = new Date().getTime()