mbit = angular.module('Microbrewit')

mbit.controller('EmbeddedSearchController', ['$scope', 'mbSearch', 'mbGet',
	($scope, search, get) ->

		$scope.results = []

		$scope.addIngredientToStep = (step, ingredient) ->
			# What kind of ingredient is it?
			if ingredient._source.dataType is 'fermentable'
				pushFermentable(step, ingredient._source)
			else if ingredient._source.dataType is 'hop'
				pushHop(step, ingredient._source)
			else if ingredient._source.dataType is 'yeast'
				pushYeast(step, ingredient._source)

			close()


		pushFermentable = (step, ingredient) ->
			push = true
			for fermentable in step.fermentables
				if ingredient.id is fermentable.id
					push = false

			if push
				ingredient = _.clone ingredient
				ingredient.amount = 0
				ingredient.mcu = 0
				ingredient.ppg = ingredient.pPG
				ingredient.gravityPoints = 0
				step.fermentables.push ingredient

		pushHop = (step, ingredient) ->
			push = true
			for hop in step.hops
				if ingredient.id is hop.id
					push = false
			if push
				ingredient = _.clone ingredient
				ingredient.amount = 0
				ingredient.form = 'pellet'
				console.log 
				ingredient.aaValue = (ingredient.aAHigh+ingredient.aALow)/2
				ingredient.aaValue = ingredient.aALow if ingredient.aAHigh is 0
				ingredient.beta = ingredient.betaHigh
				step.hops.push ingredient

		pushYeast = (step, ingredient) ->
			push = true

			console.log 'loop'
			for yeast in step.yeasts
				if ingredient.id is yeast.id
					push = false
			console.log 'push'
			if push
				ingredient = _.clone ingredient
				ingredient.amount = 0
				if ingredient.alcoholTolerance.indexOf(',') isnt -1
					alcoholTolerance = ingredient.alcoholTolerance.split(',')
					ingredient.alcoholTolerance.replace(',', ' - ')
					ingredient.alcoholToleranceRange = {low: alcoholTolerance[0], high: alcoholTolerance[1]}
				step.yeasts.push ingredient
		

		$scope.close = () -> 
			$scope.searchContext.active = false

		close = () ->
			$scope.searchContext.active = false

		$scope.performSearch = (query) ->
			console.log "searchQuery updated #{query}"
			# save used query to scope

			endpoint = "search/ingredients"

			if query? and query.length >= 3
				search(query, endpoint).async().then((apiResponse) ->
					console.log 'success'
					$scope.results = apiResponse.hits.hits
					console.log apiResponse.hits.hits

					#$scope.resultsNumber = $scope.results.length
				, (error) ->
					console.log 'error')
			else
				$scope.results = []
				$scope.resultsNumber = 0   
])