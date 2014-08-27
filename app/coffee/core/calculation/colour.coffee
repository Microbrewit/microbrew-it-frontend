# ABV formulas 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/calculation/colour', []).
factory('colourCalc', ['conversion', (conversion) ->
	colourCalc = {}

	# Malt Color Units weight in lbs., volume of wort (in gal.)
	mcu = (weight, lovibond, postBoilVolume) ->
		return (conversion.convert(weight, 'kg', 'lbs')*lovibond/conversion.convert(postBoilVolume, 'liters', 'gallons'))

	# most accurate
	colourCalc.morey = (weight, lovibond, postBoilVolume) ->
		return 1.4922 * Math.pow(mcu(weight, lovibond, postBoilVolume), 0.6859)

	colourCalc.daniels = (weight, lovibond, postBoilVolume) ->
		return (0.2 * mcu(weight, lovibond, postBoilVolume)) + 8.4

	colourCalc.mosher = (weight, lovibond, postBoilVolume) ->
		return (0.3 * mcu(weight, lovibond, postBoilVolume)) + 4.7

	return colourCalc
	# this.srmToEbc = function (srm) {
	# 	return srm*1.97;
	# };
	# this.ebcToSrm = function (ebc) {
	# 	return ebc/1.97;
	# };

])