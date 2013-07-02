'use strict';

/* Filters */

angular.module('microbrewit.filters', []).
  filter('interpolate', ['version', function(version) {
    return function(text) {
      return String(text).replace(/\%VERSION\%/mg, version);
    }
  }]).
  filter('gravatar', function () {
  	return function (email) {
		return md5(email.replace(/\s+/g, '').toLowerCase());
	}
  });
