# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/Calculation')
	.factory('abv', (convert, _) ->
		formulas = {}

		formulas.available = () ->
			return ['miller', 'simple', 'alternativeSimple', 'advanced', 'alternativeAdvanced', 'microbrewit']

		# Dave Miller, 1988
		formulas.miller = (og, fg) ->
			return ((og-fg)/0.75)*100

		# George Fix (Unimplemented)
		formulas.fix = () ->

		# Rule of thumb
		formulas.simple = (og, fg) ->
			return (og-fg)*131.25

		formulas.alternativeSimple = (og, fg) ->

			return ((1.05/0.79)*((og-fg/fg))*100)

		formulas.advanced = (og, fg) ->
			return (og-fg)*(100.3*(og-fg) + 125.65)

		formulas.alternativeAdvanced = (og, fg) ->
			return (76.08 * (og-fg) / (1.775-og)) * (fg / 0.794)
		
		formulas.microbrewit = (og, fg) ->
			return ((@alternativeSimple(og, fg)+@alternativeAdvanced(og,fg)+@simple(og, fg)+@advanced(og,fg)+@miller(og, fg))/5)

	
		formulas.calc = (og, fg, formula) ->
			formula = 'microbrewit' unless @[formula]

			calc = @[formula](og, fg)
			return if not _.isNaN(calc) then calc else 0

		return formulas
	)