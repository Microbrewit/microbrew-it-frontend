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

		$scope.removeFromStep = (thing, thingArr) ->
			index = thingArr.indexOf(thing)
			thingArr.splice(index,1);
			updateStepNumbers()

		$scope.search = (step, type) ->
			$scope.searchContext = {
				active: true
				endpoint: type 
				step: step
			}

		$scope.showSearch = false

		$scope.searchContext = {
			active: false
			endpoint: null 
			step: null
		}

		# Setup default recipe
		$scope.recipe = {}

		$scope.recipe.mash = [
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