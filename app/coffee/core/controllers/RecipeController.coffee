mbit = angular.module('Microbrewit')

mbit.controller('RecipeController', [
	'$scope'
	'mbGet'
	'mbSet'
	'localStorage'
	'sessionStorage'
	'$stateParams'
	($scope, mbGet, mbSet, localStorage, sessionStorage, $stateParams) ->

		# Are we adding a clone?
		if $stateParams.clone?
			console.log 'BEER CLONE'

		else if $stateParams.fork?
			console.log 'FORK OF RECIPE'

		$scope.hopTypes = ['pellet', 'flower']

		# if $scope.user
		# 	$scope.settings = $scope.user.settings
		# else
		# 	$scope.settings = $scope.defaults.settings
		
		# get ingredients
		sessionId = "recipe-#{new Date().getTime()}"

		$scope.$watch 'recipe', () ->
			
			sessionRecipes = sessionStorage.getItem('recipes')
			
			if typeof sessionRecipes is 'object'
				if sessionRecipes?[sessionId]?
					sessionRecipes[sessionId] = $scope.recipe
					sessionStorage.setItem('recipes', sessionRecipes)
			else
				sessionRecipes = {}
				sessionRecipes[sessionId] = $scope.recipe
				sessionStorage.setItem('recipes', sessionRecipes)

		# There must be a better way
		updateStepNumbers = () ->
			for i in [0...$scope.recipe.mash.length]
				$scope.recipe.mash[i].number = i+1
			for i in [0...$scope.recipe.boil.length]
				$scope.recipe.boil[i].number = $scope.recipe.mash.length+i+1
			for i in [0...$scope.recipe.fermentation.length]
				$scope.recipe.fermentation[i].number = $scope.recipe.mash.length+$scope.recipe.boil.length+i+1

		mashProto = {
			type: "infusion"
			length: 60
			volume: 20
			temperature: 65
			fermentables: []
			hops: []
			spices: []
			fruits: []
			notes: ""
		}
		boilProto = {
			length: 60
			volume: 20
			fermentables: []
			hops: []
			spices: []
			fruits: []
			notes: ""
		}
		fermentProto = {
			number: 3
			type: 'primary fermentation'
			length: 14
			temperature: 24
			fermentables: []
			hops: []
			spices: []
			fruits: []
			yeast: []
			notes: ""
		}
		# add 
		$scope.addMashStep = () ->
			console.log 'Add mash step'
			$scope.recipe.mash.push(_.clone mashProto)
			updateStepNumbers()

		$scope.addBoilStep = () ->
			console.log 'Add boil step'
			$scope.recipe.boil.push(_.clone boilProto)
			updateStepNumbers()
		
		$scope.addFermentationStep = () ->
			console.log 'Add fermentation step'
			$scope.recipe.fermentation.push(_.clone fermentProto)
			updateStepNumbers()

		$scope.addFermentableToStep = (step) ->
			step.fermentables.push({ name: "lol" })
		$scope.addHopsToStep = (step) ->
			step.hops.push({ name: "lol" })
		$scope.addYeastToStep = (step) ->
			step.yeasts.push({ name: "lol" })


		# --- Convenience search methods ---
		searchHops = (hop, elem) ->
			mbSearch(hop, 'hops').async().then()

		searchMalt = (malt, elem) ->
			mbSearch(malt, 'fermentables').async().then()

		searchYeast = (yeast, elem) ->
			mbSearch(yeast, 'yeasts').async().then(
				(yeasts) ->

			)

		# Setup default recipe
		$scope.recipe = {}

		$scope.recipe.mash = [
			{
				number: 1
				type: "infusion"
				length: 60
				volume: 20
				temperature: 65
				fermentables: [
					{
						id: "1377073452234"
						href: "http://microbrew.it/ontology.owl#Boortmalt_Amber_Malt"
						name: "Amber Malt"
						colour: "20"
						ppg: "34"
						suppliedbyid: "http://microbrew.it/ontology.owl#Boortmalt"
						origin: 'Germany'
						suppliedBy: 'Boortmalt'
						amount: 20,
						colourContribution: 0
					}
				]
				hops: [{
						id: "1377073452234"
						href: "http://microbrew.it/ontology.owl#Boortmalt_Amber_Malt"
						name: "Some Hop"
						aa: "20"
						ppg: "34"
						type: "pellet"
						suppliedbyid: "http://microbrew.it/ontology.owl#Boortmalt"
						origin: 'Germany'
						suppliedBy: 'Boortmalt'
						amount: 20,
						colourContribution: 0
					}]
				spices: []
				fruits: []
				notes: ""
			}
		]

		$scope.recipe.boil = [
			{
				number: $scope.recipe.mash.length+1
				length: 60
				volume: 20
				fermentables: []
				hops: [
					{
						id: "1377073452234"
						href: "http://microbrew.it/ontology.owl#Boortmalt_Amber_Malt"
						name: "Some Hop"
						aa: "20"
						ppg: "34"
						suppliedbyid: "http://microbrew.it/ontology.owl#Boortmalt"
						origin: 'Germany'
						suppliedBy: 'Boortmalt'
						amount: 20,
						colourContribution: 0
					},
					{
						id: "1377073452234"
						href: "http://microbrew.it/ontology.owl#Boortmalt_Amber_Malt"
						name: "Some Hop"
						aa: "20"
						ppg: "34"
						suppliedbyid: "http://microbrew.it/ontology.owl#Boortmalt"
						origin: 'Germany'
						suppliedBy: 'Boortmalt'
						amount: 20,
						colourContribution: 0
					}
				]
				spices: []
				fruits: []
				notes: ""
			}
		]

		$scope.recipe.fermentation = [
			{
				number: 3
				type: 'primary fermentation'
				length: 14
				temperature: 24
				fermentables: []
				hops: []
				spices: []
				fruits: []
				yeast: []
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