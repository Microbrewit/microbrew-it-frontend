# ABV formulas 
#
# @author Torstein Thune
# @copyright 2014 Microbrew.it
angular.module('Microbrewit/core/calculation/ColourCalc', []).
factory('colourCalc', ['conversion', (conversion) ->
	colourCalc = {}

	srmRgbMap = {"0.1":"248,248,230","0.2":"248,248,220","0.3":"247,247,199","0.4":"244,249,185","0.5":"247,249,180","0.6":"248,249,178","0.7":"244,246,169","0.8":"245,247,166","0.9":"246,247,156","1":"243,249,147","1.1":"246,248,141","1.2":"246,249,136","1.3":"245,250,128","1.4":"246,249,121","1.5":"248,249,114","1.6":"243,249,104","1.7":"246,248,107","1.8":"248,247,99","1.9":"245,247,92","2":"248,247,83","2.1":"244,248,72","2.2":"248,247,73","2.3":"246,247,62","2.4":"241,248,53","2.5":"244,247,48","2.6":"246,249,40","2.7":"243,249,34","2.8":"245,247,30","2.9":"248,245,22","3":"246,245,19","3.1":"244,242,22","3.2":"244,240,21","3.3":"243,242,19","3.4":"244,238,24","3.5":"244,237,29","3.6":"238,233,22","3.7":"240,233,23","3.8":"238,231,25","3.9":"234,230,21","4":"236,230,26","4.1":"230,225,24","4.2":"232,225,25","4.3":"230,221,27","4.4":"224,218,23","4.5":"229,216,31","4.6":"229,214,30","4.7":"223,213,26","4.8":"226,213,28","4.9":"223,209,29","5":"224,208,27","5.1":"224,204,32","5.2":"221,204,33","5.3":"220,203,29","5.4":"218,200,32","5.5":"220,197,34","5.6":"218,196,41","5.7":"217,194,43","5.8":"216,192,39","5.9":"213,190,37","6":"213,188,38","6.1":"212,184,39","6.2":"214,183,43","6.3":"213,180,45","6.4":"210,179,41","6.5":"208,178,42","6.6":"208,176,46","6.7":"204,172,48","6.8":"204,172,52","6.9":"205,170,55","7":"201,167,50","7.1":"202,167,52","7.2":"201,166,51","7.3":"199,162,54","7.4":"198,160,56","7.5":"200,158,60","7.6":"194,156,54","7.7":"196,155,54","7.8":"198,151,60","7.9":"193,150,60","8":"191,146,59","8.1":"190,147,57","8.2":"190,147,59","8.3":"190,145,60","8.4":"186,148,56","8.5":"190,145,58","8.6":"193,145,59","8.7":"190,145,58","8.8":"191,143,59","8.9":"191,141,61","9":"190,140,58","9.1":"192,140,61","9.2":"193,138,62","9.3":"192,137,59","9.4":"193,136,59","9.5":"195,135,63","9.6":"191,136,58","9.7":"191,134,67","9.8":"193,131,67","9.9":"190,130,58","10":"191,129,58","10.1":"191,131,57","10.2":"191,129,58","10.3":"191,129,58","10.4":"190,129,55","10.5":"191,127,59","10.6":"194,126,59","10.7":"188,128,54","10.8":"190,124,55","10.9":"193,122,55","11":"190,124,55","11.1":"194,121,59","11.2":"193,120,56","11.3":"190,119,52","11.4":"182,117,54","11.5":"196,116,59","11.6":"191,118,56","11.7":"190,116,57","11.8":"191,115,58","11.9":"189,115,56","12":"191,113,56","12.1":"191,113,53","12.2":"188,112,57","12.3":"190,112,55","12.4":"184,110,52","12.5":"188,109,55","12.6":"189,109,55","12.7":"186,106,50","12.8":"190,103,52","12.9":"189,104,54","13":"188,103,51","13.1":"188,103,51","13.2":"186,101,51","13.3":"186,102,56","13.4":"185,100,56","13.5":"185,98,59","13.6":"183,98,54","13.7":"181,100,53","13.8":"182,97,55","13.9":"177,97,51","14":"178,96,51","14.1":"176,96,49","14.2":"177,96,55","14.3":"178,95,55","14.4":"171,94,55","14.5":"171,92,56","14.6":"172,93,59","14.7":"168,92,55","14.8":"169,90,54","14.9":"168,88,57","15":"165,89,54","15.1":"166,88,54","15.2":"165,88,58","15.3":"161,88,52","15.4":"163,85,55","15.5":"160,86,56","15.6":"158,85,57","15.7":"158,86,54","15.8":"159,84,57","15.9":"156,83,53","16":"152,83,54","16.1":"150,83,55","16.2":"150,81,56","16.3":"146,81,56","16.4":"147,79,54","16.5":"147,79,55","16.6":"146,78,54","16.7":"142,77,51","16.8":"143,79,53","16.9":"142,77,54","17":"141,76,50","17.1":"140,75,50","17.2":"138,73,49","17.3":"135,70,45","17.4":"136,71,49","17.5":"140,72,49","17.6":"128,70,45","17.7":"129,71,46","17.8":"130,69,47","17.9":"123,69,45","18":"124,69,45","18.1":"121,66,40","18.2":"120,67,40","18.3":"119,64,38","18.4":"116,63,34","18.5":"120,63,35","18.6":"120,62,37","18.7":"112,63,35","18.8":"111,62,36","18.9":"109,60,34","19":"107,58,30","19.1":"106,57,31","19.2":"107,56,31","19.3":"105,56,28","19.4":"105,56,28","19.5":"104,52,31","19.6":"102,53,27","19.7":"100,53,26","19.8":"99,52,25","19.9":"93,53,24","20":"93,52,26","20.1":"89,49,20","20.2":"90,50,21","20.3":"91,48,20","20.4":"83,48,15","20.5":"88,48,17","20.6":"86,46,17","20.7":"81,45,15","20.8":"83,44,15","20.9":"81,45,15","21":"78,42,12","21.1":"77,43,12","21.2":"75,41,12","21.3":"74,41,5","21.4":"78,40,23","21.5":"83,43,46","21.6":"78,43,41","21.7":"78,40,41","21.8":"76,41,41","21.9":"74,39,39","22":"74,39,39","22.1":"69,39,35","22.2":"70,37,37","22.3":"68,38,36","22.4":"64,35,34","22.5":"64,35,34","22.6":"62,33,32","22.7":"58,33,31","22.8":"61,33,31","22.9":"58,33,33","23":"54,31,27","23.1":"52,29,28","23.2":"52,29,28","23.3":"49,28,27","23.4":"48,27,26","23.5":"48,27,26","23.6":"44,25,25","23.7":"44,25,23","23.8":"42,24,26","23.9":"40,23,22","24":"38,23,22","24.1":"38,23,22","24.2":"38,23,22","24.3":"38,23,22","24.4":"38,23,22","24.5":"38,23,22","24.6":"38,23,22","24.7":"38,23,22","24.8":"38,23,22","24.9":"38,23,22","25":"38,23,22","25.1":"38,23,22","25.2":"38,23,22","25.3":"38,23,22","25.4":"38,23,22","25.5":"38,23,22","25.6":"38,23,24","25.7":"25,16,15","25.8":"25,16,15","25.9":"25,16,15","26":"25,16,15","26.1":"25,16,15","26.2":"25,16,15","26.3":"25,16,15","26.4":"25,16,15","26.5":"25,16,15","26.6":"25,16,15","26.7":"25,16,15","26.8":"25,16,15","26.9":"25,16,15","27":"25,16,15","27.1":"25,16,15","27.2":"25,16,15","27.3":"18,13,12","27.4":"18,13,12","27.5":"18,13,12","27.6":"18,13,12","27.7":"18,13,12","27.8":"18,13,12","27.9":"18,13,12","28":"18,13,12","28.1":"18,13,12","28.2":"18,13,12","28.3":"18,13,12","28.4":"18,13,12","28.5":"18,13,12","28.6":"18,13,12","28.7":"17,13,10","28.8":"18,13,12","28.9":"16,11,10","29":"16,11,10","29.1":"16,11,10","29.2":"16,11,10","29.3":"16,11,10","29.4":"16,11,10","29.5":"16,11,10","29.6":"16,11,10","29.7":"16,11,10","29.8":"16,11,10","29.9":"16,11,10","30":"16,11,10","30.1":"16,11,10","30.2":"16,11,10","30.3":"16,11,10","30.4":"16,11,10","30.5":"14,9,8","30.6":"15,10,9","30.7":"14,9,8","30.8":"14,9,8","30.9":"14,9,8","31":"14,9,8","31.1":"14,9,8","31.2":"14,9,8","31.3":"14,9,8","31.4":"14,9,8","31.5":"14,9,8","31.6":"14,9,8","31.7":"14,9,8","31.8":"14,9,8","31.9":"14,9,8","32":"15,11,8","32.1":"12,9,7","32.2":"12,9,7","32.3":"12,9,7","32.4":"12,9,7","32.5":"12,9,7","32.6":"12,9,7","32.7":"12,9,7","32.8":"12,9,7","32.9":"12,9,7","33":"12,9,7","33.1":"12,9,7","33.2":"12,9,7","33.3":"12,9,7","33.4":"12,9,7","33.5":"12,9,7","33.6":"12,9,7","33.7":"10,7,7","33.8":"10,7,5","33.9":"8,7,7","34":"8,7,7","34.1":"8,7,7","34.2":"8,7,7","34.3":"8,7,7","34.4":"8,7,7","34.5":"8,7,7","34.6":"8,7,7","34.7":"8,7,7","34.8":"8,7,7","34.9":"8,7,7","35":"8,7,7","35.1":"8,7,7","35.2":"8,7,7","35.3":"7,6,6","35.4":"7,6,6","35.5":"7,6,6","35.6":"7,6,6","35.7":"7,6,6","35.8":"7,6,6","35.9":"7,6,6","36":"7,6,6","36.1":"7,6,6","36.2":"7,6,6","36.3":"7,6,6","36.4":"7,6,6","36.5":"7,6,6","36.6":"7,6,6","36.7":"7,7,4","36.8":"6,6,3","36.9":"6,5,5","37":"4,5,4","37.1":"4,5,4","37.2":"4,5,4","37.3":"4,5,4","37.4":"4,5,4","37.5":"4,5,4","37.6":"4,5,4","37.7":"4,5,4","37.8":"4,5,4","37.9":"4,5,4","38":"4,5,4","38.1":"4,5,4","38.2":"4,5,4","38.3":"4,5,4","38.4":"4,5,4","38.5":"3,4,3","38.6":"4,5,4","38.7":"3,4,3","38.8":"3,4,3","38.9":"3,4,3","39":"3,4,3","39.1":"3,4,3","39.2":"3,4,3","39.3":"3,4,3","39.4":"3,4,3","39.5":"3,4,3","39.6":"3,4,3","39.7":"3,4,3","39.8":"3,4,3","39.9":"3,4,3","40":"3,4,3"}

	# Malt Color Units weight in lbs., volume of wort (in gal.)
	colourCalc.mcu = (weight, lovibond, postBoilVolume) ->
		return (conversion.convert(weight, 'kg', 'lbs')*lovibond/conversion.convert(postBoilVolume, 'liters', 'gallons'))

	# most accurate
	colourCalc.morey = (weight, lovibond, postBoilVolume) ->
		return 1.4922 * Math.pow(@mcu(weight, lovibond, postBoilVolume), 0.6859)

	colourCalc.daniels = (weight, lovibond, postBoilVolume) ->
		return (0.2 * @mcu(weight, lovibond, postBoilVolume)) + 8.4

	colourCalc.mosher = (weight, lovibond, postBoilVolume) ->
		return (0.3 * @mcu(weight, lovibond, postBoilVolume)) + 4.7

	colourCalc.srmToEbc = (srm) ->
		return srm*1.97

	colourCalc.ebcToSrm = (ebc) ->
		return ebc/1.97

	colourCalc.ebcToRgb = (ebc) ->
		return @srmToRgb(@ebcToSrm(ebc))

	colourCalc.srmToRgb = (srm) ->
		if srm > 40
			return "3,4,3"
		if srm <= 0
			return "255,255,255"

		# We need to do some parsing of the srm values due to limits in the srmRgbMap
		srm = parseFloat(srm)
		srm = srm.toFixed(1).toString().replace('.0','')
		
		return srmRgbMap[srm]

	return colourCalc

])