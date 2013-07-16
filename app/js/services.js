'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('microbrewit.services', []).
	value('version', '0.1').
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
			console.log("MCU: " + this.mcu(weight, lovibond, postBoilVolume));
			return (0.3 * this.mcu(weight, lovibond, postBoilVolume)) + 4.7;
		};
	}]).
	service('mbIbuCalc', function () {
		// Tinseth specific?
		this.hopUtilisation = function (og, boilTime) {
			var a = Math.pow(1.65*0.000125, og-1);
			var b = Math.pow(og-1,-0.04*boilTime);
			return a*(b/4.14);
		};

		this.tinseth = function (weight, alphaAcid, batchSize, og, boilTime) {
			// Tinseth: IBU = Utilization * ( oz of hops * ( Alpha Acid% / 100 ) * 7490 ) / Gallons of Wort
			return (weight*alphaAcid*1000*this.hopUtilisation(og, boilTime))/batchSize;
		};
		this.roger = function () {

		};
	}).
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
	service('user', function ($cookies, $cookieStore, $rootScope) {
		this.isLogged = function () {
			if($cookieStore.get('mb_auth')) {
				return true;
			} else if($rootScope.user) {
				return true;
			}

			return false;
		};
		this.getDetails = function () {
			return $cookieStore.get('mb_user');
		};
		this.setCookie = function (userObj) {
			if(!$cookies.mb_user) {
				$cookies.mb_user = userObj;
			} else {
				$cookieStore.put('mb_user', userObj);
			}
		};
		this.removeCookie = function () {
			$cookieStore.remove('mb_user');
		};
	}).
	service('api', function ($http, $rootScope, $location, user) {

		var endpoint = "http://api.microbrew.it:3000";

		// user api
		this.addUser = function (userObj) {
			if(!user.isLogged && !$rootScope.user) {
				$http.jsonp(endpoint + '/user/add?username=' + userObj.username + '&password=' + userObj.password + '&settings=' + userObj.settings + '&callback=JSON_CALLBACK', {method: 'GET'}).
				success(function(data, status, headers, config) {
					$rootScope.user = data.user; // set logged user to responded user
					user.setCookie(data.user); // set a cookie with user data
					$location.path('/profile'); // send to settings
				}).
				error(function(data, status, headers, config) {
					return false; // TODO: display error
				});
			} else {
				return false;
			}
		};
		this.login = function (username, password) {
			if(!user.isLogged && !$rootScope.user) {
				$http.jsonp(endpoint + '/user/login?username=' + $scope.username + '&password=' + $scope.password + '&callback=JSON_CALLBACK', {method: 'GET'}).
				success(function(data, status, headers, config) {
					$rootScope.user = data.user; // set logged user to responded user
					user.setCookie(data.user); // set a cookie with user data

					$location.path('/profile'); // send to settings

				}).
				error(function(data, status, headers, config) {
					return false; // TODO: display error
				});
			} else {
				return false;
			}
		};
		this.logout = function () {};
		this.updateUser = function (username, password, breweryName, settings) {};
		this.userFollowing = function () {};
		this.userStarred = function () {};
		this.userStream = function () {};

		// beer api
		this.addBeer = function (beerObj, beerId) {};
		this.updateBeer = function (beerObj, beerId) {};

		// brewery api


		// search api
		this.search = function (searchObj) {};

	}).
	service('mbcalc', function () {
	this.SGtoPlato = function (sg) {
		return ((-463.371) + (668.7183 * sg) - (205.347 * (sg*sg)));
	};
	this.PlatotoSG = function (plato) {
		return (plato/258.6-(plato/258.2*227.1)+1);
	};
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
	}

	this.abwGeorgeFix = function (initialPlato, finalPlato) {
		return ((initialPlato-this.realExtract(initialPlato, finalPlato))/(2.0665-(0.010665*initialPlato)));
	};

	// calories for 1ml beer
	this.calories = function (abw, realExtract, fg) {
		return ((((6.9*abw)+4.0*(realExtract-0.1))*fg)/100);
	};

  });
