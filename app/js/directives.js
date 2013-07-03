'use strict';

/* Directives */


angular.module('microbrewit.directives', []).
  directive('appVersion', ['version', function(version) {
    return function (scope, elm, attrs) {
      elm.text(version);
    };
  }]).
  directive('gravatar', function() {
	return {
		restrict: 'E',
		scope: 'isolate',
		replace: true,
		transclude: true,
		template: '<div class="avatar gravatar"><img src="http://www.gravatar.com/avatar/{{email | gravatar}}" alt="" /></div>',
		compile: function (element, attr, transclusionFunc) {
			return function (scope, iterStartElement, attr) {
				var origElem = transclusionFunc(scope);
				var content =  origElem.text();
				console.log(content);
				scope.mail = content;
            };
        }
    };
}).
  directive('activeLink', ['$location', function(location) {
    return {
        restrict: 'A',
        link: function(scope, element, attrs, controller) {
            var clazz = attrs.activeLink;
            var path = attrs.href;
            path = path.substring(1); //hack because path does bot return including hashbang
            scope.location = location;
            scope.$watch('location.path()', function(newPath) {
                if (path === newPath) {
                    element.addClass(clazz);
                } else {
                    element.removeClass(clazz);
                }
            });
        }

    };

}]);
