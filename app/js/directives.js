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
    directive('mbMaltList', function (mbSrmCalc, $http, mbUser) {
        return {
            restrict: 'EA',
            transclude: true,
            visibility: "=",
            template: '<div class="malts sixteen columns no-padding">' +
                    '<div class="zebra malts offset-bottom-by-one desktop-table">' +
                        '<div class="desktop-th">' +
                            '<div class="desktop-td">Amount</div>' +
                            '<div class="desktop-td twelve columns no-padding no-float">Name of malt</div>' +
                            '<div class="desktop-td">Colour</div>' +
                            '<div class="desktop-td">PPG</div>' +
                            '<div class="desktop-td text-right">&nbsp;</div>' +
                        '</div>' +
                        '<div class="desktop-tr" ng-repeat="malt in fermentables.malts" class="clearfix">' +
                            '<div class="desktop-td"><input type="text" id="malt-weight" class="small" ng-model="malt.weight" /><label for="malt-weight"> {{settings.units.largeWeight}}</label></div>' +
                            '<div class="desktop-td twelve columns no-padding no-float"><label for="malt-name"></label><input type="text" id="malt-name" class="full-width" ng-model="malt.name" placeholder="Fermentable" /></div>' +
                            '<div class="desktop-td"><input type="text" id="malt-lovibond" class="small" ng-model="malt.lovibond" /><label for="malt-lovibond"> °L</label></div>' +
                            '<div class="desktop-td"><input type="text" id="malt-ppg" class="small" ng-model="malt.ppg" /><label for="malt-ppg"></label></div>' +
                            '<div class="desktop-td text-right"><button ng-click="fermentables.removeMalt(this)">-</button></div>' +
                        '</div>' +
                    '</div>' +
                    '<button class="left" ng-click="fermentables.removeEmpty()">Remove empty</button>'+
                    '<button ng-click="fermentables.addMalt()">Add</button>' +
                '</div>',
            replace: true,
            link: function (scope, elem, attr) {

                // setup settings if undefined by controller
                if(typeof scope.settings === "undefined") {
                    if(typeof scope.user.settings === "undefined") {
                        console.log('setting std settings');
                        scope.settings = mbUser.standardSettings;
                    } else {
                        scope.settings = scope.user.settings;
                    } 
                }
               
                // setup empty fermentables model if undefined
                if(typeof scope.fermentables === "undefined") {
                    scope.fermentables = {
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
                    var colour = 0;
                    
                    // daniels
                    if(updatedScope.settings.formula.colour === "daniels") {
                        for(var i = 0;i<updatedScope.fermentables.malts.length;i++) {
                            colour += mbSrmCalc.daniels(updatedScope.fermentables.malts[i].weight, updatedScope.fermentables.malts[i].lovibond, updatedScope.mashVolume);
                        }
                    }
                    // mosher
                    else if(updatedScope.settings.formula.colour === "mosher") {
                        for(var i = 0;i<updatedScope.fermentables.malts.length;i++) {
                            colour += mbSrmCalc.mosher(updatedScope.fermentables.malts[i].weight, updatedScope.fermentables.malts[i].lovibond, updatedScope.mashVolume);
                        }
                    }
                    // use user's preferred formula. Morey is more reliable, therefore set as default
                    else {
                        for(var i = 0;i<updatedScope.fermentables.malts.length;i++) {
                            colour += mbSrmCalc.morey(updatedScope.fermentables.malts[i].weight, updatedScope.fermentables.malts[i].lovibond, updatedScope.mashVolume);
                        } 
                    }

                    // convert to EBC if applicable
                    if(scope.settings.units.colour == "ebc") {
                        colour = mbSrmCalc.srmToEbc(colour);
                    }

                    updatedScope.fermentables.srm = colour.toFixed(2);
                };

                // setup listeners
                scope.$watch('fermentables', performCalc, true);
                scope.$watch('settings', performCalc, true);
            }
        };
    }).
    directive('mbMessage', function () {
        return {
            restrict: 'A',
            template: '<div class="{{mbMessage.messageType}} message">{{mbMessage.messageText}} <button ng-click="removeMessage(scope)">close</button></div>',
            replace: true,
            link: function (scope) {
                var showMessage = function (a, b, updatedScope) {

                }
                scope.$watch('mbMessage', showMessage, true);

                scope.removeMessage = function () {
                    console.log('');
                }
            }
        };
    }).
    directive('mbMainNavigation', function (mbUser) {
        return {
            restrict: 'A',
            link: function (scope, element, attr) {
                 console.log(element.find('.login'));
                console.log(element.children);
                // append('<li style="width: 100px" class="profile"><a href="#/profile" active-link="active">Profile</a></li>');
                // login.after('<li style="width: 100px" class="profile"><a href="#/profile" active-link="active">Profile</a></li>');

                if(mbUser.isLogged()) {
                    var conditionalNav = '';
                }
                else {
                    var conditionalNav = '<li style="width: 100px"><a href="#/login" active-link="active">Login</a></li>';
                }
            }
        }

    });