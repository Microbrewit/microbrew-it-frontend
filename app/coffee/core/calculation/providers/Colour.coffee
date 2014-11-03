# Formulas to calculate SRM from an MCU value
# All formulas require metric
# Requires calcObjs which contains either an mcu or weight, lovibond and postBoilVolume
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Calculation')
	.factory('colour', ['convert', (convert) ->
		formulas = {}

		# Return available formulas
		formulas.available = () ->
			return ['morey', 'daniels', 'mosher']

		# Calculate mcu
		# MCU takes metric values
		# @param [number/kg] weight
		# @param [number] lovibond
		# @param [number/liters]postBoilVolume
		# @return [number] MCU
		formulas.mcu = (weight, lovibond, postBoilVolume) ->
			weight = convert.convert(weight, 'kg', 'lbs')
			volume = convert.convert(postBoilVolume, 'liters', 'gallons')

			return (weight*lovibond/volume)

		# Morey
		# @return [float] srm
		formulas.morey = (calcObj) ->
			calcObj.mcu = @mcu(weight, lovibond, postBoilVolume) unless calcObj.mcu?

			return 1.4922 * Math.pow(calcObj.mcu, 0.6859)
		
		# Daniels
		# @return [float] srm
		formulas.daniels = (calcObj) ->
			calcObj.mcu = @mcu(weight, lovibond, postBoilVolume) unless calcObj.mcu?

			return (0.2 * calcObj.mcu) + 8.4

		# Mosher
		# @return [float] srm
		formulas.mosher = (calcObj) ->
			calcObj.mcu = @mcu(weight, lovibond, postBoilVolume) unless calcObj.mcu?
			return (0.3 * calcObj.mcu) + 4.7

		return formulas
	])