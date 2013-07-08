'use strict';

/* Directives */


angular.module('microbrewit.directives', []).
    directive('gravatar', function() {
        return {
            restrict: 'E',
            scope: 'isolate',
            replace: true,
            template: '<div class="avatar gravatar"><img src="http://www.gravatar.com/avatar/{{src}}" style="width:{{size}};height:{{size}}" alt="" /></div>',
            link: function (scope, element, attr) {
                attr.$observe('src', function(current_value) {
                    scope.src = md5(current_value.replace(/\s+/g, '').toLowerCase()); // create gravatar hash of interpolated value, push to scope
                });

                scope.size = attr.size; // set size (width = height) of gravatar
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
    }]).
    directive('mbError', function() {
        return {
            restrict: 'A',
            template: '<div class="error-message>{{errormessage}}</div>',
            link: function (scope, element, attr) {
                // attr.$observe('src', function(current_value) {
                //     scope.src = md5(current_value.replace(/\s+/g, '').toLowerCase()); // create gravatar hash of interpolated value, push to scope
                // });

                scope.errormessage = element.text(); // set size (width = height) of gravatar
            }
        };
    });
