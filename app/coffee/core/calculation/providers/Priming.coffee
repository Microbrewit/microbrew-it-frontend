# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Calculation')
	.factory('priming', () ->
		formulas = {}

		formulas.dme = (wantedCarbonation, beerVolume, currentCarbonation) ->
			currentCarbonation ?= 0

			# mDME =  + 1/((0.5 * 0.82 * 0.80 * / beerVolume)/wantedCarbonation-currentCarbonation);
			# wantedCarbonation = currentCarbonation  + 0.5 * 0.82 * 0.80 * mDME / beerVolume;
		formulas.caneSugar = (wantedCarbonation, beerVolume, currentCarbonation) ->
			currentCarbonation ?= 0

			# wantedCarbonation = currentCarbonation + 0.5 * canesugar /beerVolume;
			# canesugar = ((wantedCarbonation - currentCarbonation)/0.5)*beerVolume);
			return ((wantedCarbonation - currentCarbonation) / 0.5) * beerVolume # g of sugar

		formulas.cornsugar = (wantedCarbonation, beerVolume, currentCarbonation) ->
			currentCarbonation = currentCarbonation || 0
			# Cbeer = Cflat-beer + 0.5 * 0.91 * mcorn-sugar / Vbeer
			# Cbeer - the final carbonation of the beer (g/l)
			# Cflat-beer - the CO2 content of the beer before bottling (g/l)
			# mcorn-sugar - the weight of the corn sugar (glucose monohydrate) (g)
			# Vbeer - beer volume (l)

		return formulas
	)