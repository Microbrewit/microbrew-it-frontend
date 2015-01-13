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
		$scope.searchContext = {
			active: false
			endpoint: null 
			step: null
		}

		if $stateParams.fork?
			if $rootScope.beerToFork?
				$scope.beer.recipe = _.clone $rootScope.beerToFork.recipe
				$rootScope.beerToFork = undefined
			else
				mbGet.beers({id:$stateParams.fork}).then((response) ->
					$scope.beer.recipe = response.beers[0].recipe
				)


		$scope.hopTypes = []

		mbGet.hopForms().then((response) ->
			$scope.hopForms = response
		)

		mbGet.beerstyles().then((response) ->
			$scope.beerStyles = response.beerStyles
			$scope.beer.recipe.beerStyle = $scope.beerStyles[0]
		)
		
		# get ingredients
		sessionId = "recipe-#{new Date().getTime()}"

		$scope.updateFermentableValues = () ->
			totalMCU = 0
			totalGP = 0

			for step in $scope.beer.recipe.mashSteps
				for ingredient in step.fermentables
					totalGP+=parseFloat ingredient.gravityPoints
					totalMCU+=parseFloat ingredient.mcu

			for step in $scope.beer.recipe.boilSteps
				for ingredient in step.fermentables
					totalGP+=parseFloat ingredient.gravityPoints
					totalMCU+=parseFloat ingredient.mcu

			calcOG(totalGP)
			calcColour(totalMCU)
			calcAbv()

		$scope.updateHopsValues = () ->
			totalIBU = 0
			
			for step in $scope.beer.recipe.mashSteps
				for ingredient in step.hops
					totalIBU+=ingredient.ibu if ingredient.ibu and not isNaN(ingredient.ibu)

			for step in $scope.beer.recipe.boilSteps 
				for ingredient in step.hops
					totalIBU+=ingredient.ibu if ingredient.ibu and not isNaN(ingredient.ibu)

		calcGravity = (totalGP) ->
			totalGP = parseInt(totalGP)
			$scope.beer.recipe.og = (1 + totalGP/1000).toFixed(3)
			$scope.beer.recipe.fg = (($scope.beer.recipe.og-1)*(1-0.75)+1).toFixed(3)

		calcAbv = () ->

		calcIbu = () ->

		
		calcColour = (totalMCU) ->
			$scope.beer.mcu = totalMCU
			$scope.beer.srm = 
				parseInt(1.4922 * Math.pow(totalMCU, 0.6859))

		# There must be a better way
		updateStepNumbers = () ->
			for i in [0...$scope.beer.recipe.mashSteps.length]
				$scope.beer.recipe.mashSteps[i].stepNumber = i+1
			for i in [0...$scope.beer.recipe.boilSteps.length]
				$scope.beer.recipe.boilSteps[i].stepNumber = $scope.beer.recipe.mashSteps.length+i+1
			for i in [0...$scope.beer.recipe.fermentationSteps.length]
				$scope.beer.recipe.fermentationSteps[i].stepNumber = $scope.beer.recipe.mashSteps.length+$scope.beer.recipe.boilSteps.length+i+1

		mashProto = {
			stepNumber: 1
			type: "infusion"
			length: 60
			volume: 20
			temperature: 65
			stepType: "mashSteps"
			fermentables: []
			hops: []
			others: []
			yeasts: []
			notes: ""
		}
		boilProto = {
			stepNumber: 2
			length: 60
			volume: 20
			stepType: "boilSteps"
			fermentables: []
			hops: []
			others: []
			yeasts: []
			notes: ""
		}
		fermentProto = {
			stepNumber: 3
			stepType: "fermentationSteps"
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
			$scope.beer.recipe.mashSteps.push(_.clone mashProto)
			updateStepNumbers()

		$scope.addBoilStep = () ->
			console.log 'Add boil step'
			$scope.beer.recipe.boilSteps.push(_.clone boilProto)
			updateStepNumbers()
		
		$scope.addFermentationStep = () ->
			console.log 'Add fermentation step'
			$scope.beer.recipe.fermentationSteps.push(_.clone fermentProto)
			updateStepNumbers()

		$scope.removeStep = (step) ->
			index = $scope.beer.recipe[step.stepType].indexOf(step)
			$scope.beer.recipe[step.stepType].splice(index,1)
			updateStepNumbers()

		$scope.removeFromStep = (thing, thingArr) ->
			index = thingArr.indexOf(thing)
			thingArr.splice(index,1);
			updateStepNumbers()

		$scope.submitRecipe = () ->
			console.log 'submitRecipe'
			mbSet.recipe($scope.beer.recipe).async().then()

		$scope.logRecipe = () ->
			console.log JSON.stringify($scope.beer.recipe,  null, '\t')

		$scope.search = (step, type) ->
			$scope.searchContext = {
				active: true
				endpoint: type 
				step: step
			}

		$rootScope.modal = $scope.searchContext.active

		$scope.addIngredientToStep = (step, ingredient) ->
			ingredient = _.clone(ingredient)

			if ingredient.dataType is 'fermentable'
				ingredient.amount = 0
				ingredient.mcu = 0
				ingredient.gravityPoints = 0

				step.fermentables.push(ingredient)

			else if ingredient.dataType is 'hop'
				ingredient.amount = 0
				ingredient.hopForm = $scope.hopTypes[0]

				step.hops.push(ingredient)

			else if ingredient.dataType is 'yeast'

				step.yeasts.push(ingredient)

			updateStepNumbers()

		unless $stateParams.fork

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

			$scope.beer.recipe.mashSteps = []
			$scope.beer.recipe.mashSteps.push _.clone mashProto

			$scope.beer.recipe.boilSteps = []
			$scope.beer.recipe.boilSteps.push _.clone boilProto

			$scope.beer.recipe.fermentationSteps = []
			$scope.beer.recipe.fermentationSteps.push _.clone fermentProto

			$scope.beer.recipe.priming = [
				{
					fermentables: []
					notes: ''
				}
			]

			$scope.beer.recipe.notes = ""

])