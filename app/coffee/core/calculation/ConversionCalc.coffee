# Conversion formulas 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/calculation/ConversionCalc', []).
	service('conversion', ($log) ->

		@sg =
			plato: (sg) ->
				return (-463.371) + (668.7183 * sg) - (205.347 * (sg*sg))
		
		@plato =
			sg: (plato) ->
				return plato/(258.6-((plato/258.2)*227.1))+1

		@oz =
			lbs: (oz) ->
				return oz*0.0625
			grams: (oz) ->
				return oz/0.035274

		@grams =
			oz: (grams) ->
				return grams*0.035274
			kg: (grams) ->
				return grams/1000

		@kg =
			grams: (kg) ->
				return kg*1000
			lbs: (kg) ->
				return kg*2.2046

		@lbs =
			oz: (lbs) ->
				return lbs/0.0625
			kg: (lbs) ->
				return lbs/2.2046

		@celcius =
			farenheit: (celcius) ->
				return celcius*1.8 + 32

		@farenheit =
			celcius: (farenheit) ->
				return (farenheit-32)/1.8

		@liters =
			gallons: (liters) ->
				return liters/3.78541178

		@gallons =
			liters: (gallons) ->
				return gallons*3.78541178

		# Pellet utilisation <-> Flower utilisation (pellets gives ~6-7% more utilisation, though some say 10% or 15%)
		@hop =
			pellet: (weight) ->
				return weight*0.93

		@pellet =
			hop: (weight) ->
				return weight*1.07

		@convert = (amount, from, to) ->
			if typeof from is string and typeof to is string
				if @[from]?[to]
					return @[from][to](amount)
				else
					$log.error("Cannot convert #{from} to #{to} in Microbrewit/core/calculation/conversion.")
	)