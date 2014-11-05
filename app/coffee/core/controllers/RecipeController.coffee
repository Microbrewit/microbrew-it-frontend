mbit = angular.module('Microbrewit')

mbit.controller('RecipeController', [
	'$rootScope'
	'$scope'
	'mbGet'
	'mbSet'
	'localStorage'
	'sessionStorage'
	'$stateParams'
	'_'
	'colour'
	($rootScope, $scope, mbGet, mbSet, localStorage, sessionStorage, $stateParams, _, colourCalc) ->

		console.log $scope.user
		console.log '### STATEPARAMS'
		console.log $stateParams
		# Are we adding a clone?
		if $stateParams.clone?
			console.log 'BEER CLONE'

		else if $stateParams.fork?
			if $rootScope.beerToFork?
				$scope.recipe = _.clone $rootScope.beerToFork.recipe
				$rootScope.beerToFork = undefined
			else
				mbGet.beers({id:$stateParams.fork}).async().then((response) ->
					$scope.recipe = response.beers[0].recipe
				)

		$scope.hopTypes = ['pellet', 'flower']

		mbGet.beerstyles().async().then((response) ->
			$scope.beerStyles = response.beerStyles
			$scope.recipe.beerStyle = $scope.beerStyles[0]
		)

		# if $scope.user
		# 	$scope.settings = $scope.user.settings
		# else
		# 	$scope.settings = $scope.defaults.settings
		
		# get ingredients
		sessionId = "recipe-#{new Date().getTime()}"

		$scope.updateFermentableValues = () ->
			totalMCU = 0
			totalGP = 0

			for step in $scope.recipe.mashSteps
				for ingredient in step.fermentables
					totalGP+=parseFloat ingredient.gravityPoints
					totalMCU+=parseFloat ingredient.mcu

			for step in $scope.recipe.boilSteps
				for ingredient in step.fermentables
					totalGP+=parseFloat ingredient.gravityPoints
					totalMCU+=parseFloat ingredient.mcu

			calcOG(totalGP)
			calcColour(totalMCU)

		$scope.updateHopsValues = () ->
			totalIBU = 0
			
			for step in $scope.recipe.mashSteps
				for ingredient in step.hops
					totalIBU+=ingredient.ibu if ingredient.ibu and not isNaN(ingredient.ibu)

			for step in $scope.recipe.boilSteps 
				for ingredient in step.hops
					totalIBU+=ingredient.ibu if ingredient.ibu and not isNaN(ingredient.ibu)

		calcOG = (totalGP) ->
			totalGP = parseInt(totalGP)
			$scope.recipe.og = (1 + totalGP/1000).toFixed(3)
			calcFG()
		calcFG = ->
			$scope.recipe.fg = (($scope.recipe.og-1)*(1-0.75)+1).toFixed(3)

		calcColour = (totalMCU) ->
			console.log "totalMCU: #{totalMCU}"
			$scope.recipe.srm = parseInt(1.4922 * Math.pow(totalMCU, 0.6859))

		# There must be a better way
		updateStepNumbers = () ->
			for i in [0...$scope.recipe.mashSteps.length]
				$scope.recipe.mashSteps[i].number = i+1
			for i in [0...$scope.recipe.boilSteps.length]
				$scope.recipe.boilSteps[i].number = $scope.recipe.mashSteps.length+i+1
			for i in [0...$scope.recipe.fermentationSteps.length]
				$scope.recipe.fermentationSteps[i].number = $scope.recipe.mashSteps.length+$scope.recipe.boilSteps.length+i+1

		mashProto = {
			type: "infusion"
			length: 60
			volume: 20
			temperature: 65
			fermentables: []
			hops: []
			others: []
			yeasts: []
			notes: ""
		}
		boilProto = {
			length: 60
			volume: 20
			fermentables: []
			hops: []
			others: []
			yeasts: []
			notes: ""
		}
		fermentProto = {
			number: 3
			type: 'primary fermentation'
			length: 14
			temperature: 24
			fermentables: []
			hops: []
			others: []
			yeasts: []
			notes: ""
		}
		# add 
		$scope.addMashStep = () ->
			console.log 'Add mash step'
			$scope.recipe.mashSteps.push(_.clone mashProto)
			updateStepNumbers()

		$scope.addBoilStep = () ->
			console.log 'Add boil step'
			$scope.recipe.boilSteps.push(_.clone boilProto)
			updateStepNumbers()
		
		$scope.addFermentationStep = () ->
			console.log 'Add fermentation step'
			$scope.recipe.fermentationSteps.push(_.clone fermentProto)
			updateStepNumbers()

		$scope.removeFromStep = (thing, thingArr) ->
			index = thingArr.indexOf(thing)
			thingArr.splice(index,1);
			updateStepNumbers()

		$scope.submitRecipe = () ->
			console.log 'submitRecipe'
			mbSet.recipe($scope.recipe).async().then()

		$scope.logRecipe = () ->
			console.log JSON.stringify($scope.recipe,  null, '\t')

		$scope.search = (step, type) ->
			$scope.searchContext = {
				active: true
				endpoint: type 
				step: step
			}

		$scope.addIngredientToStep = (step, ingredient) ->
			ingredient = _.clone(ingredient)

			if ingredient.dataType is 'fermentable'
				ingredient.amount = 0
				ingredient.mcu = 0
				ingredient.gravityPoints = 0

				step.fermentables.push(ingredient)

			else if ingredient.dataType is 'hop'
				ingredient.amount = 0
				ingredient.form = 'pellet'

				step.hops.push(ingredient)

			else if ingredient.dataType is 'yeast'

				step.yeasts.push(ingredient)

			updateStepNumbers()

		$scope.showSearch = false

		$scope.searchContext = {
			active: false
			endpoint: null 
			step: null
		}

		unless $stateParams.fork
			# Setup default recipe
			$scope.recipe = {
				name: ''
				brewer: {}
				ibu: 0
				abv: 0
				srm: 0
				og: 0
				fg: 0
				volume: 20
				efficiency: 70
			}

			$scope.recipe.mashSteps = [
				{
					number: 1
					type: "infusion"
					length: 60
					volume: 20
					temperature: 65
					fermentables: []
					hops: []
					spices: []
					fruits: []
					yeasts: []
					notes: ""
				}
			]

			$scope.recipe.boilSteps = [
				{
					number: $scope.recipe.mashSteps.length+1
					length: 60
					volume: 20
					fermentables: []
					hops: []
					spices: []
					fruits: []
					yeasts: []
					notes: ""
				}
			]

			$scope.recipe.fermentationSteps = [
				{
					number: 3
					type: 'primary fermentation'
					length: 14
					temperature: 24
					fermentables: []
					hops: []
					spices: []
					fruits: []
					yeasts: []
					notes: ""
				}
			]

			$scope.recipe.priming = [
				{
					fermentables: []
					notes: ''
				}
			]

			$scope.recipe.notes = ""

])