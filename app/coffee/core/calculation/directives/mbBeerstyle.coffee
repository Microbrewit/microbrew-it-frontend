# Directive for displaying if a beer keeps to its beer style
#
# @author Torstein Thune
# @copyright 2015 Microbrew.it
angular.module('Microbrewit/core/Calculation')
.directive('mbBeerstyle', [
	'abv'
	'colour'
	'bitterness'
	(abv, colour, bitterness) ->
		return {
			restrict: 'EA'
			scope: {
				'beer': '='
			}
			replace: true
			template: '' +
			'<div class="measureWrapper">' +
			'	<div class="measureInterval">'+
			'		<div class="styleIndicator" style="{{styleIndicatorStyle}}">' +
			'			<div class="min">{{min}}</div>' +
			'			<div class="max">{{max}}</div>' +
			'		</div>' +
			'		<div class="valueIndicator" style="{{valueStyle}}">' +
			'			<div class="value">{{value}}</div>' +
			'			<div class="legend">{{type}}</div>' +
			'		</div>' +
			'	</div>' +
			'</div>'
			link: (scope, element, attrs) ->

				scope.type = attrs.type.toUpperCase()
				scope.max = 0
				scope.min = 0
				scope.value = 0
				scope.styleIndicatorStyle = "bottom: 0;height: 10%;"
				scope.valueStyle = "bottom: 0;"

				
				compareAbv = (beer) ->
					min = 0
					max = 10
					
					console.log '#### BEER IN DIRECTIVE'
					console.log scope.beer
					percent = ((max-min)/100)

					if scope.beer.beerStyle? 
						console.log '#### ABV beerstyle check'
						scope.max = scope.beer.beerStyle.abvHigh
						scope.min = scope.beer.beerStyle.abvLow

						styleHeight =  (scope.max - scope.min)/percent
						console.log "styleHeight: #{styleHeight}"
						styleOffset = scope.min/percent

						scope.max = "#{scope.max}%"
						scope.min = "#{scope.min}%"

						scope.styleIndicatorStyle = "height:#{styleHeight}%;bottom:#{styleOffset}%"

					if scope.beer?.recipe?.og and scope.beer?.recipe?.fg
						console.log '#### ABV gravity check'
						abvVal = abv.calc(scope.beer.recipe.og, scope.beer.recipe.fg, 'microbrewit')
						valueOffset = abvVal/percent

						console.log "ABV: #{abvVal} valueOffset: #{valueOffset}"
						scope.valueStyle = "bottom:#{valueOffset}%"
						scope.value = "#{abvVal.toFixed(1)}%"

				compareBitterness = () ->
					min = 0
					max = 35
					percent = ((max-min)/100)

					if scope.beer?.beerStyle?
						scope.max = scope.beer.beerStyle.ibuHigh
						scope.min = scope.beer.beerStyle.ibuLow
						styleHeight =  (((scope.max) - (scope.min))/percent)
						console.log "#{scope.min} / #{percent} = #{scope.min/percent}"
						styleOffset = scope.min/percent

						scope.max = "#{parseInt(scope.max)}"
						scope.min = "#{parseInt(scope.min)}"

						scope.styleIndicatorStyle = "height:#{styleHeight}%;bottom:#{styleOffset}%"

					if scope.beer?.recipe?.ibu
						val = scope.beer.recipe.ibu
						valueOffset = val/percent

						scope.valueStyle = "bottom:#{valueOffset}%"
						scope.value = "#{parseInt(val)}"

				compareColour = () ->
					min = 0
					max = 40
					percent = ((max-min)/100)

					if scope.beer?.beerStyle?
						scope.max = scope.beer.beerStyle.srmHigh
						scope.min = scope.beer.beerStyle.srmLow
						styleHeight =  (((scope.max) - (scope.min))/percent)
						console.log "#{scope.min} / #{percent} = #{scope.min/percent}"
						styleOffset = scope.min/percent

						scope.max = "#{parseInt(scope.max)}"
						scope.min = "#{parseInt(scope.min)}"

						scope.styleIndicatorStyle = "height:#{styleHeight}%;bottom:#{styleOffset}%"

					if scope.beer?.recipe?.srm
						val = scope.beer.recipe.srm
						valueOffset = val/percent

						scope.valueStyle = "bottom:#{valueOffset}%"
						scope.value = "#{parseInt(val)}"

				compareOG = () ->
					min = 1 * 100
					max = 1.1 * 100
					percent = ((max-min)/100)

					if scope.beer?.beerStyle?
						scope.max = scope.beer.beerStyle.ogHigh
						scope.min = scope.beer.beerStyle.ogLow
						styleHeight =  (((scope.max*100) - (scope.min*100))/percent)
						console.log "#{scope.min} / #{percent} = #{scope.min/percent}"
						styleOffset = scope.min/percent

						scope.max = "#{scope.max.toFixed(3)}"
						scope.min = "#{scope.min.toFixed(3)}"

						scope.styleIndicatorStyle = "height:#{styleHeight}%;bottom:#{styleOffset}%"

					if scope.beer?.recipe?.og
						og = scope.beer.recipe.og
						og = 1 if og is 0
						valueOffset = og/percent

						scope.valueStyle = "bottom:#{valueOffset}%"
						scope.value = "#{og.toFixed(3)}"

				compareFG = () ->
					min = 1 * 100
					max = 1.1 * 100
					percent = ((max-min)/100)

					console.log "---- fgHigh #{scope.beer.beerStyle.fgHigh}"
					if scope.beer?.beerStyle?
						scope.max = parseFloat scope.beer.beerStyle.fgHigh
						scope.min = parseFloat scope.beer.beerStyle.fgLow
						styleHeight =  (((scope.max*100) - (scope.min*100))/percent)
						console.log "#{scope.min} / #{percent} = #{scope.min/percent}"
						styleOffset = scope.min/percent

						scope.max = "#{scope.max.toFixed(3)}"
						scope.min = "#{scope.min.toFixed(3)}"

						scope.styleIndicatorStyle = "height:#{styleHeight}%;bottom:#{styleOffset}%"

					if scope.beer?.recipe?.fg
						fg = scope.beer.recipe.fg
						fg = 1 if fg is 0
						valueOffset = fg/percent

						scope.valueStyle = "bottom:#{valueOffset}%"
						scope.value = "#{fg.toFixed(3)}"

				# IBU max 110
				# SRM max 40
				# ABV: max 30
				# Gravity: max 100

				# ogLow: 1.036,
				# ogHigh: 1.056,
				# fgLow: 1.004,
				# fgHigh: 1.018,
				# ibuLow: 10,
				# ibuHigh: 35,
				# srmLow: 4,
				# srmHigh: 22,
				# abvLow: 3.5,
				# abvHigh: 5.6,

				compareToStyle = (newval) ->
					if attrs.type is 'abv'
						compareAbv(newval)
					else if attrs.type is 'og'
						compareOG(newval)
					else if attrs.type is 'fg'
						compareFG(newval)
					else if attrs.type is 'srm'
						compareColour(newval)
					else if attrs.type is 'ibu'
						compareBitterness(newval)
				# Run only once every $digest
				scope.$watch('beer', compareToStyle, true) 

		}
])