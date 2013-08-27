'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('microbrewit.services', []).
	service('mbAbvCalc', function () {
		this.miller = function (og, fg) {
			return ((og-fg)/0.75)*100; // Dave Miller, 1988
		};
		// I think this is implemented wrong
		this.fix = function (initialPlato, finalPlato) {
			return (initialPlato-((0.1808 * initialPlato) + (0.8192 * finalPlato)))/(2.0665-(0.010665*initialPlato))*0.789;
		};
		this.simple = function (og, fg) {
			return (og-fg)*131.25; // Simplified "rule of thumb"
		};
		this.advanced = function (og,fg) {
			return ((og-fg)*(100.3*(og-fg) + 125.65)); // advanced simple
		};
		this.alternativeAdvanced = function (og,fg) {
			return (76.08 * (og-fg) / (1.775-og)) * (fg / 0.794); // advanced, rumored to be more accurate at high gravities, from BrewersFriend?
		};
		this.alternativeSimple = function (og, fg) {
			return ((1.05/0.79)*((og-fg/fg))*100); // yet another formula
		};
		this.microbrewIt = function (og, fg) {
			return ((this.alternativeSimple(og, fg)+this.alternativeAdvanced(og,fg)+this.simple(og, fg)+this.advanced(og,fg)+this.miller(og, fg))/5);
		};
	}).
	service('mbSrmCalc', ['mbConversionCalc', function (mbConversionCalc) {
		this.srmToEbc = function (srm) {
			return srm*1.97;
		};
		this.ebcToSrm = function (ebc) {
			return ebc/1.97;
		};

		// Malt Color Units weight in lbs., volume of wort (in gal.)
		this.mcu = function (weight, lovibond, postBoilVolume) {
			return (mbConversionCalc.kgToLb(weight)*lovibond/mbConversionCalc.litersToGallons(postBoilVolume));
		};

		// SRM
		this.morey = function (weight, lovibond, postBoilVolume) {
			return 1.4922 * Math.pow(this.mcu(weight, lovibond, postBoilVolume), 0.6859); // most accurate
		};

		// SRM
		this.daniels = function (weight, lovibond, postBoilVolume) {
			return (0.2 * this.mcu(weight, lovibond, postBoilVolume)) + 8.4;
		};
		// SRM
		this.mosher = function (weight, lovibond, postBoilVolume) {
			return (0.3 * this.mcu(weight, lovibond, postBoilVolume)) + 4.7;
		};
	}]).
	
	service('mbConversionCalc', function () {

		/* SG <-> Plato */
		this.SGtoPlato = function (sg) {
		return ((-463.371) + (668.7183 * sg) - (205.347 * (sg*sg)));
		};
		this.PlatotoSG = function (plato) {
			return (plato/258.6-(plato/258.2*227.1)+1);
		};

		/* Pellet utilisation <-> Flower utilisation (pellets gives ~6-7% more utilisation, though some say 10% or 15%)*/
		this.pelletToHop = function (weight) {
			return weight*1.07;
		};
		this.hopToPellet = function (weight) {
			return weight*0.93;
		};

		/* Metric <-> Imperial */
		this.gramsToOz = function (grams) {
			return grams*0.035274;
		};
		this.ozToGrams = function (oz) {
			return oz/0.035274;
		};

		this.ozToLb = function (oz) {
			return oz*0.0625;
		};
		this.lbToOz = function (lb) {
			return lb/0.0625;
		};

		this.kgToLb = function (kg) {
			return kg*2.2046;
		};
		this.lbToKg = function (lb) {
			return lb/2.2046;
		};

		this.celciusToFarenheit = function (celcius) {
			return celcius*1.8 + 32;
		};
		this.farenheitToCelcius = function (farenheit) {
			return (farenheit-32)/1.8;
		};

		this.litersToGallons = function (liters) {
			return liters/3.78541178;
		};
		this.gallonsToLiters = function (gallons) {
			return gallons*3.78541178;
		};

		this.platoToSG = function (plato) {
			return (plato/(258.6-((plato/258.2)*227.1))+1);
		};

	}).
	
	
	service('fermentables', function ($http, progressbar) {
		this.getFermentables = function () {
			var promise;
			var fermentables = {
				async: function () {
					if (!promise) {
						console.log('fetching fermentables');
						promise = $http.jsonp('http://api.microbrew.it/fermentables?callback=JSON_CALLBACK', {})
							.error(function (data, status) {
								console.log(data);
								progressbar.message('Could not get fermentables from API (code: ' + status + ')', '#DE5C5C');
							})
							.then(function (response) {
							// The then function here is an opportunity to modify the response
							sessionStorage.setItem("fermentables", response.data.fermentables);
							console.log('!');
							// The return value gets picked up by the then in the controller.
							return response.data;
						});
					}
					return promise;
				}
			};
			return fermentables;
		};

	}).
	service('yeasts', function ($http, progressbar) {
		this.getYeasts = function () {
			var promise;
			var yeasts = {
				async: function () {
					if (!promise) {
						console.log('fetching yeast');
						promise = $http.jsonp('http://api.microbrew.it/yeasts?callback=JSON_CALLBACK', {})
							.error(function (data, status) {
								console.log(data);
								progressbar.message('Could not get yeasts from API (code: ' + status + ')', '#DE5C5C');
							})
							.then(function (response) {
							// The then function here is an opportunity to modify the response
							sessionStorage.setItem("yeasts", response.data.yeasts);
							console.log('!');
							// The return value gets picked up by the then in the controller.
							return response.data;
						});
					}
					return promise;
				}
			};
			return yeasts;
		};

	}).
	service('mbcalc', function () {
	this.realExtract = function (initialPlato, finalPlato) {
		return ((0.1808 * initialPlato) + (0.8192 * finalPlato));
	};
	this.attenuation = function (initialPlato, finalPlato) {
		return (1-(initialPlato/finalPlato));
	};

	// alcohol by weight
	this.abw = function (abv, fg) {
		return ((0.79 * abv)/fg);
	};

	this.abvGeorgeFix = function (initialPlato, finalPlato) {
		return (this.abwGeorgeFix(initialPlato, finalPlato)*0.789);
	};

	this.abwGeorgeFix = function (initialPlato, finalPlato) {
		return ((initialPlato-this.realExtract(initialPlato, finalPlato))/(2.0665-(0.010665*initialPlato)));
	};

	// calories for 1ml beer
	this.calories = function (abw, realExtract, fg) {
		return ((((6.9*abw)+4.0*(realExtract-0.1))*fg)/100);
	};

  }).
	service('countries', function () {
		this.countries = [ 
							{name: 'Afghanistan', code: 'AF'},
							{name: 'Åland Islands', code: 'AX'},
							{name: 'Albania', code: 'AL'},
							{name: 'Algeria', code: 'DZ'},
							{name: 'American Samoa', code: 'AS'}, 
							{name: 'AndorrA', code: 'AD'}, 
							{name: 'Angola', code: 'AO'}, 
							{name: 'Anguilla', code: 'AI'}, 
							{name: 'Antarctica', code: 'AQ'}, 
							{name: 'Antigua and Barbuda', code: 'AG'}, 
							{name: 'Argentina', code: 'AR'}, 
							{name: 'Armenia', code: 'AM'}, 
							{name: 'Aruba', code: 'AW'}, 
							{name: 'Australia', code: 'AU'}, 
							{name: 'Austria', code: 'AT'}, 
							{name: 'Azerbaijan', code: 'AZ'}, 
							{name: 'Bahamas', code: 'BS'}, 
							{name: 'Bahrain', code: 'BH'}, 
							{name: 'Bangladesh', code: 'BD'}, 
							{name: 'Barbados', code: 'BB'}, 
							{name: 'Belarus', code: 'BY'}, 
							{name: 'Belgium', code: 'BE'}, 
							{name: 'Belize', code: 'BZ'}, 
							{name: 'Benin', code: 'BJ'}, 
							{name: 'Bermuda', code: 'BM'}, 
							{name: 'Bhutan', code: 'BT'}, 
							{name: 'Bolivia', code: 'BO'}, 
							{name: 'Bosnia and Herzegovina', code: 'BA'}, 
							{name: 'Botswana', code: 'BW'}, 
							{name: 'Bouvet Island', code: 'BV'}, 
							{name: 'Brazil', code: 'BR'}, 
							{name: 'British Indian Ocean Territory', code: 'IO'}, 
							{name: 'Brunei Darussalam', code: 'BN'}, 
							{name: 'Bulgaria', code: 'BG'}, 
							{name: 'Burkina Faso', code: 'BF'}, 
							{name: 'Burundi', code: 'BI'}, 
							{name: 'Cambodia', code: 'KH'}, 
							{name: 'Cameroon', code: 'CM'}, 
							{name: 'Canada', code: 'CA'}, 
							{name: 'Cape Verde', code: 'CV'}, 
							{name: 'Cayman Islands', code: 'KY'}, 
							{name: 'Central African Republic', code: 'CF'}, 
							{name: 'Chad', code: 'TD'}, 
							{name: 'Chile', code: 'CL'}, 
							{name: 'China', code: 'CN'}, 
							{name: 'Christmas Island', code: 'CX'}, 
							{name: 'Cocos (Keeling) Islands', code: 'CC'}, 
							{name: 'Colombia', code: 'CO'}, 
							{name: 'Comoros', code: 'KM'}, 
							{name: 'Congo', code: 'CG'}, 
							{name: 'Congo, The Democratic Republic of the', code: 'CD'}, 
							{name: 'Cook Islands', code: 'CK'}, 
							{name: 'Costa Rica', code: 'CR'}, 
							{name: 'Cote D\'Ivoire', code: 'CI'}, 
							{name: 'Croatia', code: 'HR'}, 
							{name: 'Cuba', code: 'CU'}, 
							{name: 'Cyprus', code: 'CY'}, 
							{name: 'Czech Republic', code: 'CZ'}, 
							{name: 'Denmark', code: 'DK'}, 
							{name: 'Djibouti', code: 'DJ'}, 
							{name: 'Dominica', code: 'DM'}, 
							{name: 'Dominican Republic', code: 'DO'}, 
							{name: 'Ecuador', code: 'EC'}, 
							{name: 'Egypt', code: 'EG'}, 
							{name: 'El Salvador', code: 'SV'}, 
							{name: 'Equatorial Guinea', code: 'GQ'}, 
							{name: 'Eritrea', code: 'ER'}, 
							{name: 'Estonia', code: 'EE'}, 
							{name: 'Ethiopia', code: 'ET'}, 
							{name: 'Falkland Islands (Malvinas)', code: 'FK'}, 
							{name: 'Faroe Islands', code: 'FO'}, 
							{name: 'Fiji', code: 'FJ'}, 
							{name: 'Finland', code: 'FI'}, 
							{name: 'France', code: 'FR'}, 
							{name: 'French Guiana', code: 'GF'}, 
							{name: 'French Polynesia', code: 'PF'}, 
							{name: 'French Southern Territories', code: 'TF'}, 
							{name: 'Gabon', code: 'GA'}, 
							{name: 'Gambia', code: 'GM'}, 
							{name: 'Georgia', code: 'GE'}, 
							{name: 'Germany', code: 'DE'}, 
							{name: 'Ghana', code: 'GH'}, 
							{name: 'Gibraltar', code: 'GI'}, 
							{name: 'Greece', code: 'GR'}, 
							{name: 'Greenland', code: 'GL'}, 
							{name: 'Grenada', code: 'GD'}, 
							{name: 'Guadeloupe', code: 'GP'}, 
							{name: 'Guam', code: 'GU'}, 
							{name: 'Guatemala', code: 'GT'}, 
							{name: 'Guernsey', code: 'GG'}, 
							{name: 'Guinea', code: 'GN'}, 
							{name: 'Guinea-Bissau', code: 'GW'}, 
							{name: 'Guyana', code: 'GY'}, 
							{name: 'Haiti', code: 'HT'}, 
							{name: 'Heard Island and Mcdonald Islands', code: 'HM'}, 
							{name: 'Holy See (Vatican City State)', code: 'VA'}, 
							{name: 'Honduras', code: 'HN'}, 
							{name: 'Hong Kong', code: 'HK'}, 
							{name: 'Hungary', code: 'HU'}, 
							{name: 'Iceland', code: 'IS'}, 
							{name: 'India', code: 'IN'}, 
							{name: 'Indonesia', code: 'ID'}, 
							{name: 'Iran, Islamic Republic Of', code: 'IR'}, 
							{name: 'Iraq', code: 'IQ'}, 
							{name: 'Ireland', code: 'IE'}, 
							{name: 'Isle of Man', code: 'IM'}, 
							{name: 'Israel', code: 'IL'}, 
							{name: 'Italy', code: 'IT'}, 
							{name: 'Jamaica', code: 'JM'}, 
							{name: 'Japan', code: 'JP'}, 
							{name: 'Jersey', code: 'JE'}, 
							{name: 'Jordan', code: 'JO'}, 
							{name: 'Kazakhstan', code: 'KZ'}, 
							{name: 'Kenya', code: 'KE'}, 
							{name: 'Kiribati', code: 'KI'}, 
							{name: 'Korea, Democratic People\'S Republic of', code: 'KP'}, 
							{name: 'Korea, Republic of', code: 'KR'}, 
							{name: 'Kuwait', code: 'KW'}, 
							{name: 'Kyrgyzstan', code: 'KG'}, 
							{name: 'Lao People\'S Democratic Republic', code: 'LA'}, 
							{name: 'Latvia', code: 'LV'}, 
							{name: 'Lebanon', code: 'LB'}, 
							{name: 'Lesotho', code: 'LS'}, 
							{name: 'Liberia', code: 'LR'}, 
							{name: 'Libyan Arab Jamahiriya', code: 'LY'}, 
							{name: 'Liechtenstein', code: 'LI'}, 
							{name: 'Lithuania', code: 'LT'}, 
							{name: 'Luxembourg', code: 'LU'}, 
							{name: 'Macao', code: 'MO'}, 
							{name: 'Macedonia, The Former Yugoslav Republic of', code: 'MK'}, 
							{name: 'Madagascar', code: 'MG'}, 
							{name: 'Malawi', code: 'MW'}, 
							{name: 'Malaysia', code: 'MY'}, 
							{name: 'Maldives', code: 'MV'}, 
							{name: 'Mali', code: 'ML'}, 
							{name: 'Malta', code: 'MT'}, 
							{name: 'Marshall Islands', code: 'MH'}, 
							{name: 'Martinique', code: 'MQ'}, 
							{name: 'Mauritania', code: 'MR'}, 
							{name: 'Mauritius', code: 'MU'}, 
							{name: 'Mayotte', code: 'YT'}, 
							{name: 'Mexico', code: 'MX'}, 
							{name: 'Micronesia, Federated States of', code: 'FM'}, 
							{name: 'Moldova, Republic of', code: 'MD'}, 
							{name: 'Monaco', code: 'MC'}, 
							{name: 'Mongolia', code: 'MN'}, 
							{name: 'Montserrat', code: 'MS'}, 
							{name: 'Morocco', code: 'MA'}, 
							{name: 'Mozambique', code: 'MZ'}, 
							{name: 'Myanmar', code: 'MM'}, 
							{name: 'Namibia', code: 'NA'}, 
							{name: 'Nauru', code: 'NR'}, 
							{name: 'Nepal', code: 'NP'}, 
							{name: 'Netherlands', code: 'NL'}, 
							{name: 'Netherlands Antilles', code: 'AN'}, 
							{name: 'New Caledonia', code: 'NC'}, 
							{name: 'New Zealand', code: 'NZ'}, 
							{name: 'Nicaragua', code: 'NI'}, 
							{name: 'Niger', code: 'NE'}, 
							{name: 'Nigeria', code: 'NG'}, 
							{name: 'Niue', code: 'NU'}, 
							{name: 'Norfolk Island', code: 'NF'}, 
							{name: 'Northern Mariana Islands', code: 'MP'}, 
							{name: 'Norway', code: 'NO'}, 
							{name: 'Oman', code: 'OM'}, 
							{name: 'Pakistan', code: 'PK'}, 
							{name: 'Palau', code: 'PW'}, 
							{name: 'Palestinian Territory, Occupied', code: 'PS'}, 
							{name: 'Panama', code: 'PA'}, 
							{name: 'Papua New Guinea', code: 'PG'}, 
							{name: 'Paraguay', code: 'PY'}, 
							{name: 'Peru', code: 'PE'}, 
							{name: 'Philippines', code: 'PH'}, 
							{name: 'Pitcairn', code: 'PN'}, 
							{name: 'Poland', code: 'PL'}, 
							{name: 'Portugal', code: 'PT'}, 
							{name: 'Puerto Rico', code: 'PR'}, 
							{name: 'Qatar', code: 'QA'}, 
							{name: 'Reunion', code: 'RE'}, 
							{name: 'Romania', code: 'RO'}, 
							{name: 'Russian Federation', code: 'RU'}, 
							{name: 'RWANDA', code: 'RW'}, 
							{name: 'Saint Helena', code: 'SH'}, 
							{name: 'Saint Kitts and Nevis', code: 'KN'}, 
							{name: 'Saint Lucia', code: 'LC'}, 
							{name: 'Saint Pierre and Miquelon', code: 'PM'}, 
							{name: 'Saint Vincent and the Grenadines', code: 'VC'}, 
							{name: 'Samoa', code: 'WS'}, 
							{name: 'San Marino', code: 'SM'}, 
							{name: 'Sao Tome and Principe', code: 'ST'}, 
							{name: 'Saudi Arabia', code: 'SA'}, 
							{name: 'Senegal', code: 'SN'}, 
							{name: 'Serbia and Montenegro', code: 'CS'}, 
							{name: 'Seychelles', code: 'SC'}, 
							{name: 'Sierra Leone', code: 'SL'}, 
							{name: 'Singapore', code: 'SG'}, 
							{name: 'Slovakia', code: 'SK'}, 
							{name: 'Slovenia', code: 'SI'}, 
							{name: 'Solomon Islands', code: 'SB'}, 
							{name: 'Somalia', code: 'SO'}, 
							{name: 'South Africa', code: 'ZA'}, 
							{name: 'South Georgia and the South Sandwich Islands', code: 'GS'}, 
							{name: 'Spain', code: 'ES'}, 
							{name: 'Sri Lanka', code: 'LK'}, 
							{name: 'Sudan', code: 'SD'}, 
							{name: 'Suriname', code: 'SR'}, 
							{name: 'Svalbard and Jan Mayen', code: 'SJ'}, 
							{name: 'Swaziland', code: 'SZ'}, 
							{name: 'Sweden', code: 'SE'}, 
							{name: 'Switzerland', code: 'CH'}, 
							{name: 'Syrian Arab Republic', code: 'SY'}, 
							{name: 'Taiwan, Province of China', code: 'TW'}, 
							{name: 'Tajikistan', code: 'TJ'}, 
							{name: 'Tanzania, United Republic of', code: 'TZ'}, 
							{name: 'Thailand', code: 'TH'}, 
							{name: 'Timor-Leste', code: 'TL'}, 
							{name: 'Togo', code: 'TG'}, 
							{name: 'Tokelau', code: 'TK'}, 
							{name: 'Tonga', code: 'TO'}, 
							{name: 'Trinidad and Tobago', code: 'TT'}, 
							{name: 'Tunisia', code: 'TN'}, 
							{name: 'Turkey', code: 'TR'}, 
							{name: 'Turkmenistan', code: 'TM'}, 
							{name: 'Turks and Caicos Islands', code: 'TC'}, 
							{name: 'Tuvalu', code: 'TV'}, 
							{name: 'Uganda', code: 'UG'}, 
							{name: 'Ukraine', code: 'UA'}, 
							{name: 'United Arab Emirates', code: 'AE'}, 
							{name: 'United Kingdom', code: 'GB'}, 
							{name: 'United States', code: 'US'}, 
							{name: 'United States Minor Outlying Islands', code: 'UM'}, 
							{name: 'Uruguay', code: 'UY'}, 
							{name: 'Uzbekistan', code: 'UZ'}, 
							{name: 'Vanuatu', code: 'VU'}, 
							{name: 'Venezuela', code: 'VE'}, 
							{name: 'Viet Nam', code: 'VN'}, 
							{name: 'Virgin Islands, British', code: 'VG'}, 
							{name: 'Virgin Islands, U.S.', code: 'VI'}, 
							{name: 'Wallis and Futuna', code: 'WF'}, 
							{name: 'Western Sahara', code: 'EH'}, 
							{name: 'Yemen', code: 'YE'}, 
							{name: 'Zambia', code: 'ZM'}, 
							{name: 'Zimbabwe', code: 'ZW'} 
						];
		this.image = function (countryCode) {

		};
	});
