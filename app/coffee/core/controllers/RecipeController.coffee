mbit = angular.module('Microbrewit')

mbit.controller('RecipeController', [
	'$rootScope'
	'$scope'
	'mbGet'
	'mbPost'
	'localStorage'
	'sessionStorage'
	'$stateParams'
	'_'
	'colour'
	'$state'
	'mbUser'
	'mbBeer'
	($rootScope, $scope, mbGet, mbPost, localStorage, sessionStorage, $stateParams, _, colourCalc, $state, mbUser, mbBeer) ->
		$scope.searchContext = {
			active: false
			endpoint: null 
			step: null
		}
		$scope.hopTypes = []
		mbGet.hopForms().then((response) ->
			$scope.hopForms = response
			$scope.hopTypes = response
		)

		window.log = () ->
			console.log $scope

		if $state.is('fork')
			if $rootScope.beerToFork?
				$scope.beer = JSON.parse(JSON.stringify($rootScope.beerToFork)) # Deep clone the original recipe
				$rootScope.beerToFork = undefined
			else
				mbBeer.getSingle($state.params.id).then((response) ->
					$scope.beer = JSON.parse(JSON.stringify(response.beers[0]))

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

					
					# This is a fork
					$scope.beer.forkOf = 
						id: $scope.beer.id
						name: $scope.beer.name

					# Edit name and remove id since it is a fork
					$scope.beer.name += ' fork'
					$scope.beer.id = undefined
				)

		else if $state.is('edit')
			console.log 'mbBeer.get ' + mbBeer.get?
			console.log 'mbBeer.getSingle ' + mbBeer.getSingle?
			mbBeer.getSingle($state.params.id).then((response) ->
				$scope.beer = JSON.parse(JSON.stringify(response.beers[0]))
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
			)

			$scope.submitRecipe = () ->
				mbBeer.update($scope.beer).then()

		else
			mbGet.beerstyles().then((response) ->

				$scope.beerStyles = response.beerStyles
				$scope.beer.beerStyle = $scope.beerStyles[0]

				$scope.groupBeerstyles = (style)->
					return style.superBeerStyle.name if style.superBeerStyle?.name?
					return style.name
			)

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
					boilSteps: []
					fermentationSteps: []
					priming: [
						{
							fermentables: []
							notes: ''
						}
					]
					notes: ""
		
		# get ingredients
		sessionId = "recipe-#{new Date().getTime()}"

		mbGet.fermentables().then((response) ->
			$scope.fermentables = response.fermentables
			$scope.groupFermentables = (fermentable)->
				return fermentable.type
		)

		mbGet.hops().then((response) ->
			for hop in response.hops
				hop.aaValue = hop.aaLow
				if hop.aaHigh isnt 0
					hop.aaValue = (hop.aaValue + hop.aaLow) / 2
				hop.betaValue = hop.betaLow
				if hop.betaHigh isnt 0
					hop.betaValue = (hop.betaValue+ hop.aaLow) / 2
				hop.hopForm = $scope.hopForms[0]

			$scope.hops = response.hops
			$scope.groupHops = (hops)->
				return hops.origin.name if hops.origin?.name?
				return 'other'
		)

		mbGet.yeasts().then((response) ->
			$scope.yeasts = response.yeasts
			$scope.groupYeasts = (yeast)->
				return yeast.supplier.name if yeast.supplier?.name?
				return 'Other'
		)

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

			calcGravity(totalGP)
			calcColour(totalMCU)

		$scope.updateHopsValues = () ->
			calcIbu()

		calcGravity = (totalGP) ->
			totalGP = parseInt(totalGP)
			$scope.beer.recipe.og = (1 + totalGP/1000).toFixed(3)
			$scope.beer.recipe.fg = (($scope.beer.recipe.og-1)*(1-0.75)+1).toFixed(3)

		calcIbu = () ->
			totalIBU = 0
			
			for step in $scope.beer.recipe.mashSteps
				for ingredient in step.hops
					totalIBU+=ingredient.ibu if ingredient.ibu and not isNaN(ingredient.ibu)

			for step in $scope.beer.recipe.boilSteps 
				for ingredient in step.hops
					totalIBU+=ingredient.ibu if ingredient.ibu and not isNaN(ingredient.ibu)

			console.log "total IBU: #{totalIBU}"
			$scope.beer.ibu.tinseth = parseInt(totalIBU, 10)
		
		calcColour = (totalMCU) ->
			$scope.beer.mcu = totalMCU
			$scope.beer.srm.standard = parseInt(1.4922 * Math.pow(totalMCU, 0.6859))


		# There must be a better way
		updateStepNumbers = () ->
			for i in [0...$scope.beer.recipe.mashSteps.length]
				$scope.beer.recipe.mashSteps[i].stepNumber = i+1
			for i in [0...$scope.beer.recipe.boilSteps.length]
				$scope.beer.recipe.boilSteps[i].stepNumber = $scope.beer.recipe.mashSteps.length+i+1
			for i in [0...$scope.beer.recipe.fermentationSteps.length]
				$scope.beer.recipe.fermentationSteps[i].stepNumber = $scope.beer.recipe.mashSteps.length+$scope.beer.recipe.boilSteps.length+i+1

		# add 
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

		if $state.is('add')
			$scope.addMashStep()
			$scope.addBoilStep()
			$scope.addFermentationStep()

		$scope.removeStep = (step) ->
			index = $scope.beer.recipe[step.stepType].indexOf(step)
			$scope.beer.recipe[step.stepType].splice(index,1)
			updateStepNumbers()

		$scope.removeFromStep = (thing, thingArr) ->
			index = thingArr.indexOf(thing)
			thingArr.splice(index,1);
			updateStepNumbers()

		unless $scope.submitRecipe?
			$scope.submitRecipe = () ->

				console.log 'submitRecipe'

				# well fuck
				if not $scope.token?
					# we need username and password
					mbUser.login($scope.username,$scope.password,false).then(mbPost.recipe($scope.beer).async().then())

				else if $scope.token?.token?.expires <= new Date().getTime()
					# We need to refresh token
					mbUser.login(false,false,$scope.token).then(mbPost.recipe($scope.beer).async().then())
				
				else
					# Alles in order
					mbPost.recipe($scope.beer).async().then()

		$scope.change =() ->

		$scope.search = (step, type) ->
			$scope.searchContext = {
				active: true
				endpoint: type 
				step: step
			}
		# Refresh scope var
		$scope.refreshIngredient = (ingredient, model) ->
			console.log 'refresh ingredient'

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
		$scope.addIngredientToStep = (step, ingredient) ->

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

			# else
			# 	step.other.push(ingredient)

])