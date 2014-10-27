# Conversion formulas 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/calculation/ConversionCalc', []).
	factory('conversion', ['$log', ($log) ->
		conversionFormulas = {}
		conversionFormulas.sg =
			plato: (sg) ->
				return (-463.371) + (668.7183 * sg) - (205.347 * (sg*sg))
		
		conversionFormulas.plato =
			sg: (plato) ->
				return plato/(258.6-((plato/258.2)*227.1))+1

		conversionFormulas.oz =
			lbs: (oz) ->
				return oz*0.0625
			grams: (oz) ->
				return oz/0.035274

		conversionFormulas.grams =
			oz: (grams) ->
				return grams*0.035274
			kg: (grams) ->
				return grams/1000

		conversionFormulas.kg =
			grams: (kg) ->
				return kg*1000
			lbs: (kg) ->
				return kg*2.2046

		conversionFormulas.lbs =
			oz: (lbs) ->
				return lbs/0.0625
			kg: (lbs) ->
				return lbs/2.2046

		conversionFormulas.celcius =
			farenheit: (celcius) ->
				return celcius*1.8 + 32

		conversionFormulas.farenheit =
			celcius: (farenheit) ->
				return (farenheit-32)/1.8

		conversionFormulas.liters =
			gallons: (liters) ->
				return liters/3.78541178

		conversionFormulas.gallons =
			liters: (gallons) ->
				return gallons*3.78541178

		# Pellet utilisation <-> Flower utilisation (pellets gives ~6-7% more utilisation, though some say 10% or 15%)
		conversionFormulas.hop =
			pellet: (weight) ->
				return weight*0.93

		conversionFormulas.pellet =
			hop: (weight) ->
				return weight*1.07

		conversionFormulas.lovibond = 
			srm: (lovibond) ->
				return lovibond*1.35-0.6
			ebc: (lovibond) ->
				return (lovibond*1.35-0.6)*1.97

		conversionFormulas.srm = 
			lovibond: (srm) ->
				return (srm+0.6)/1.35
			ebc: (srm) ->
				return srm*1.97

		conversionFormulas.ebc = 
			lovibond: (ebc) ->
			srm: (ebc) ->
				return ebc/1.97

		conversionFormulas.convert = (amount, from, to) ->
			if typeof from is 'string' and typeof to is 'string' and @[from]?[to]?
				convertedValue = @[from][to](amount)
				console.log "@[#{from}][#{to}](#{amount}) = #{convertedValue}"
				return convertedValue

		return conversionFormulas
	])