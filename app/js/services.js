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
	service('mbIbuCalc', function () {
		// Tinseth
		this.tinsethUtilisation = function (og, boilTime) {
			var boilTimeFactor = (1-Math.exp(-0.04*boilTime))/4.15;
			var bignessFactor = 1.65*Math.pow(0.000125, (og-1));
			var utilisation = bignessFactor * boilTimeFactor;
			return utilisation;
		};
		this.tinsethMgl = function (weight, alphaAcid, batchSize) {
			// mg/L
			alphaAcid = alphaAcid/100;

			return (alphaAcid*weight*1000)/batchSize;
		};

		this.tinsethIbu = function (mgl, utilisation) {
			return utilisation*mgl;
		};

		// Rager
		this.tanh = function (x) {
			var e = Math.exp(2*x);
			return (e-1)/(e+1);
		};

		this.ragerUtilisation = function (boilTime) {
			return (18.11 + 13.86 * this.tanh((boilTime-31.32)/18.27)) / 100;
		};

		this.ragerIbu = function (weight, utilisation, alphaAcid, boilVolume, boilGravity) {
			var ga = 0;
			alphaAcid = alphaAcid/100;
			if(boilGravity > 1.050) {
				ga = (boilGravity-1.050)/0.2;
			}
			return (weight * utilisation * alphaAcid * 1000) / (boilVolume * (1+ga));
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
	service('mbUser', function ($cookies, $cookieStore, $rootScope, $http, $resource, $location) {
		this.standardSettings = {
			units: {
				colour: 'srm',
				bitterness: 'ibu',
				temperature: 'celcius',
				smallWeight: 'grams',
				largeWeight: 'kg',
				liquid: 'liters'
			},
			formula: {
				colour: 'morey',
				bitterness: 'tinseth',
				abv: 'microbrewit'
			},
			mashVolume: 20,
			efficiency: 70
				
		};
		// takes in a userObj that you want to add to the user db in the API
		this.update = function (userObj) {
			$http.defaults.useXDomain = true;

			$http.post('http://api.microbrew.it/users', userObj).
			success(function (data) {
				// on success login
				$rootScope.user = data.user;

				$location.path('/');

				if(typeof data.message !== 'undefined') {
					console.log(data.message);
				}

			}).
			error(function (error) {
				if(typeof error.error !== 'undefined') {
					console.log(error.error);
				}
			});
		};

		// TODO: test/fix
		this.login = function (userObj) {
			if(!this.isLogged()) {
				$http.post('http://api.microbrew.it/users/login/', {id:userObj.username,password:userObj.password}).
				success(function (data) {
					this.setupUserSession(data.user);
				}).
				error(function (error) {

				});
			} else if (typeof $rootScope.user === "undefined" || typeof $rootScope.user.username === "undefined") {
				$rootScope.user = this.getDetailsFromCookie();
			}
		};

		this.logout = function () {
			if(this.isLogged) {
				$http.post('http://api.microbrew.it/users/logout', {}).
				success(function (data) {
					this.destroyUserSession();
				}).
				error(function (error) {});
			}
		};

		this.setupUserSession = function (userObj) {
			this.setCookie(userObj);
			$rootScope.user = userObj;
			$rootScope.isLogged = true;
		};

		this.destroyUserSession = function () {
			this.removeCookie();
			$rootScope.user = {};
			$rootScope.isLogged = false;
		};

		this.isLogged = function () {
			// do we have a user cookie?
			if($cookieStore.get('mb_user')) {
				return true;
			}

			// do we have a user object?
			else if(typeof $rootScope.user !== "undefined" && $rootScope.user.username) {
				return true;
			}

			return false;
		};

		this.getDetailsFromCookie = function () {
			return $cookieStore.get('mb_user');
		};

		this.setCookie = function (userObj) {
			$cookieStore.put('mb_user', userObj);
		};

		this.removeCookie = function () {
			$cookieStore.remove('mb_user');
		};
	}).
	service('hops', function ($http) {
		this.getHops = function () {
			var promise;
			var hops = {
				async: function () {
					if (!promise) {
						console.log('?');
						promise = $http.jsonp('http://api.microbrew.it/hops?callback=JSON_CALLBACK', {}).then(function (response) {
							// The then function here is an opportunity to modify the response
							sessionStorage.setItem("hops", response.data.hops);
							console.log('!');
							// The return value gets picked up by the then in the controller.
							return response.data;
						});
					}
					return promise;
				}
			};
			return hops;
		};
		this.updateHops = function () {};

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

  });
