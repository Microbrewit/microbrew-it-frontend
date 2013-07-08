'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('microbrewit.services', []).
	value('version', '0.1').
	service('mbcalc', function () {
	this.SGtoPlato = function (SG) {
		return ((-463.371) + (668.7183 * SG) - (205.347 * (SG*SG)));
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

	/* 	ABV - Alcohol By Volume
		I have no idea which is more accurate */
	this.abvMiller = function (og, fg) {
		return ((og-fg)/0.75)*100; // Dave Miller, 1988
	};
	this.abvFix = function (og, fg) {
		return this.abvGeorgeFix(this.SGtoPlato(og), this.SGtoPlato(fg)); // George Fix, 1992
	};
	this.abvSimple = function (og, fg) {
		return (og-fg)*131.25; // Simplified "rule of thumb"
	};
	this.abvAdvanced = function (og,fg) {
		return ((og-fg)*(100.3*(og-fg) + 125.65)); // advanced simple
	};
	this.abvAlternativeAdvanced = function (og,fg) {
		return (76.08 * (og-fg) / (1.775-og)) * (fg / 0.794); // advanced, rumored to be more accurate at high gravities, from BrewersFriend?
	};
	this.abvAlternativeSimple = function (og, fg) {
		return ((1.05/0.79)*((og-fg/fg))*100); // yet another formula
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
