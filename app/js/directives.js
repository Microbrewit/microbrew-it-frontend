'use strict';

/* Directives */


angular.module('microbrewit.directives', []).
    directive('gravatar', function() {
        return {
            restrict: 'E',
            scope: 'isolate',
            replace: true,
            template: '<div class="avatar gravatar round"><img src="http://www.gravatar.com/avatar/{{src}}" style="width:{{size}};height:{{size}}" alt="" /></div>',
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
    }).
    directive('mbCalcAbv', function(mbAbvCalc, mbConversionCalc) {
    	return {
    		restrict: 'EA',
    		scope: 'isolate',
    		template: '<div class="abv">{{abv}}% ({{formula}})</div>',
    		link: function (scope, element, attr) {
    			var formulaToUse = "";

    			function calcAbv(og, fg) {
    				if(formulaToUse == "fix") {
    					return mbAbvCalc.fix(mbConversionCalc.SGtoPlato(og), mbConversionCalc.SGtoPlato(fg));
    				}
    				else if(formulaToUse == "miller") {
    					return mbAbvCalc.miller(og, fg);
    				}
    				else if(formulaToUse == "advanced") {
    					return mbAbvCalc.advanced(og,fg);
    				}
    				else if(formulaToUse == "alternativeAdvanced") {
    					return mbAbvCalc.alternativeAdvanced(og,fg);
    				}
    				else if(formulaToUse == "simple") {
    					return mbAbvCalc.simple(og, fg);
    				}
    				else if(formulaToUse == "alternativeSimple") {
    					return mbAbvCalc.alternativeSimple(og, fg);
    				} else {
    					return mbAbvCalc.microbrewIt(og, fg);
    				}
    			}

    			attr.$observe('formula', function (formula) {
    				formulaToUse = formula;
    				scope.formula = formula;
    			});

    			attr.$observe('og', function (og) {
    				scope.abv = calcAbv(og, attr.fg).toFixed(2);
    			});

    			attr.$observe('fg', function (fg) {
    				scope.abv = calcAbv(attr.og, fg).toFixed(2);
    			});
    		}
    	};
	}).
    directive('mbMaltList', function (mbSrmCalc, $http) {
        return {
            restrict: 'EA',
            transclude: true,
            visibility: "=",
            template: '<div class="malts">' +
                    '<ul class="zebra malts">' +
                        '<li ng-repeat="malt in fermentables.malts">' +
                            '<label for="malt-name"></label><input type="text" id="malt-name" ng-model="malt.name" />' +
                            '<input type="text" id="malt-lovibond" ng-model="malt.lovibond" /><label for="malt-lovibond">°L</label>' +
                            '<input type="text" id="malt-weight" ng-model="malt.weight" /><label for="malt-weight">kg</label>' +
                            '<button ng-click="fermentables.removeMalt(this)">-</button>' +
                        '</li>' +
                    '</ul>' +
                    '<button class="left" ng-click="fermentables.removeEmpty()">Remove empty</button>'+
                    '<button ng-click="fermentables.addMalt()">Add</button>' +
                '</div>',
            replace: true,
            link: function (scope, elem, attr) {

                // check if fermentables are defined, set up mock if not
                if(typeof scope.fermentables === "undefined") {
                    scope.fermentables = {
                        formula: "srm",
                        srm: 0,
                        malts: [{name:"", lovibond: 0, weight: 0},{name:"", lovibond: 0, weight: 0}]
                    };
                }

                if(typeof scope.mashVolume === "undefined") {
                    scope.mashVolume = 20;
                }

                // set up functions called by buttons
                scope.fermentables.addMalt = function () {
                    this.malts.push({name:"", lovibond: 0, weight: 0});
                };

                // look for built in functionality for doing this ;D
                scope.fermentables.removeMalt = function (listElem) {
                    var hashKey = listElem.malt.$$hashKey;
                    scope.fermentables.malts = _(scope.fermentables.malts).reject(function(el) { return el.$$hashKey == hashKey; });
                };
                // look for built in functionality for doing this ;D
                scope.fermentables.removeEmpty = function () {
                    scope.fermentables.malts = _(scope.fermentables.malts).reject(function(el) { return el.weight === 0 && el.lovibond === 0; });
                };

                var performCalc = function(a, b, updatedScope) {
                    var srm = 0;
                    for(var i = 0;i<updatedScope.fermentables.malts.length;i++) {
                        srm += mbSrmCalc.morey(updatedScope.fermentables.malts[i].weight, updatedScope.fermentables.malts[i].lovibond, updatedScope.mashVolume);
                    }

                    if(scope.fermentables.formula == "ebc") {
                        srm = mbSrmCalc.srmToEbc(srm);
                    }
                    scope.fermentables.srm = srm.toFixed(2);
                };

                // setup listeners
                scope.$watch('fermentables.malts', performCalc, true);
                scope.$watch('mashVolume', performCalc, true);


                // scope.$watch('fermentables.formula', function(formula) {
                //     if(formula == "ebc") {
                //         scope.fermentables.srm = mbSrmCalc.srmToEbc(scope.mbSrmCalc.srm);
                //     } else if(formula == "srm") {
                //         scope.fermentables.srm = mbSrmCalc.ebcToSrm(scope.mbSrmCalc.srm);
                //     }
                // });
            }
        };
    });