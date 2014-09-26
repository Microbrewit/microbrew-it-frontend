mbit = angular.module('Microbrewit')

mbit.controller('RecipeController', ['$scope', 'mbGet', 'mbSet', 'localStorage', 'sessionStorage', ($scope, mbGet, mbSet, localStorage, sessionStorage) ->
	# if $scope.user
	# 	$scope.settings = $scope.user.settings
	# else
	# 	$scope.settings = $scope.defaults.settings
	
	# get ingredients
	sessionId = "recipe-#{new Date().getTime()}"

	$scope.$watch 'recipe', () ->
		console.log 'scope updated'
		
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

	# add 
	$scope.addMashStep = () ->
		console.log 'Add mash step'
		$scope.recipe.mash.push({})
		updateStepNumbers()

	$scope.addBoilStep = () ->
		console.log 'Add boil step'
		$scope.recipe.boil.push({})
		updateStepNumbers()
	
	$scope.addFermentationStep = () ->
		console.log 'Add fermentation step'
		$scope.recipe.fermentation.push({})
		updateStepNumbers()

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
			hops: []
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
			hops: []
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