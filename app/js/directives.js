'use strict';

/* Directives */


angular.module('microbrewit.directives', []).
  directive('appVersion', ['version', function(version) {
    return function(scope, elm, attrs) {
      elm.text(version);
    };
  }]).
  directive('gravatar', function() {
	var returnz = md5(contents(elem).replace(/\s+/g, '').toLowerCase());
	return {
		restrict: "E",
		template: "<img src='http://gravata.com/avatar/"+returnz+"'' />"
	};
});
