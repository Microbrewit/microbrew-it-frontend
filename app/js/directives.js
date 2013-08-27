'use strict';

/* Directives */


angular.module('microbrewit.directives', []).
    directive('gravatar', function() {
        return {
            restrict: 'E',
            scope: 'isolate',
            replace: true,
            template: '<div class="avatar gravatar"><img src="http://www.gravatar.com/avatar/{{src}}"  class="round" style="width:{{size}};height:{{size}}" alt="" /></div>',
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
    directive('mbHopsList', function (mbIbuCalc, mbConversionCalc, mbUser, hops) {
        return {
            restrict: 'EA',
            // transclude: true,
            // visibility: "=",
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

                if(typeof scope.hopsDb === "undefined") {
                    console.log(hops.getHops().async().then());
                    hops.getHops().async().then(function(data) {
                        scope.hopsDb=data.hops;
                        console.log('HopDB: ');
                        console.log(scope.hops);
                    });
                }
               
                // setup empty fermentables model if undefined
                if(typeof scope.ibu === "undefined") {
                    scope.ibu = 0;
                }
                if(typeof scope.hops === "undefined") {
                    scope.hops = [];
                }
                console.log(scope.hops);
                if(typeof scope.boilVolume === "undefined") {
                    scope.boilVolume = 20;
                }
                if(typeof scope.boilGravity === "undefined") {
                    scope.boilGravity = 1.040;
                }

                // set up functions called by buttons
                scope.addHops = function () {
                    this.hops.push({name:"", lovibond: 0, weight: 0});
                };

                scope.addHop = function(scope) {
                    scope.hops.push(this.hop);
                }

                // look for built in functionality for doing this ;D
                scope.removeHops = function (listElem) {
                    var hashKey = listElem.hop.$$hashKey;
                    scope.hops = _(scope.hops).reject(function(el) { return el.$$hashKey == hashKey; });
                };
                // look for built in functionality for doing this ;D
                scope.removeEmptyHops = function () {
                    scope.hops = _(scope.hops).reject(function(el) { return el.weight === 0 && el.aa === 0; });
                };

                var performCalc = function(a, b, updatedScope) {
                    var totalibu = 0,
                        ibu = 0,
                        utilisation,
                        mgl,
                        i;

                    // rager
                    if(updatedScope.settings.formula.bitterness === "rager") {
                        for(i = 0;i<updatedScope.hops.length;i++) {
                            utilisation = mbIbuCalc.ragerUtilisation(updatedScope.hops[i].boiltime);

                            if(updatedScope.hops[i].type == "pellet") {
                               utilisation = mbConversionCalc.pelletToHop(utilisation);
                            }
                            mgl = mbIbuCalc.tinsethMgl(updatedScope.hops[i].weight, updatedScope.hops[i].aa, updatedScope.boilVolume);

                            // function (weight, utilisation, alphaAcid, boilVolume, boilGravity) {
                            ibu = mbIbuCalc.ragerIbu(updatedScope.hops[i].weight, utilisation, updatedScope.hops[i].aa, updatedScope.boilVolume, updatedScope.boilGravity);
                            
                            // update hop scope with values
                            updatedScope.hops[i].utilisation = utilisation.toFixed(2);
                            updatedScope.hops[i].mgl = mgl.toFixed(2);
                            updatedScope.hops[i].ibu = ibu.toFixed(2);

                            // update scope with total ibu
                            totalibu += ibu;
                        }
                    } else {
                        // this.tinseth = function (weight, alphaAcid, batchSize, og, boilTime)
                        for(i = 0;i<updatedScope.hops.length;i++) {
                            utilisation = mbIbuCalc.tinsethUtilisation(updatedScope.boilGravity, updatedScope.hops[i].boiltime);

                            if(updatedScope.hops[i].type == "pellet") {
                               utilisation = mbConversionCalc.pelletToHop(utilisation);
                            }
                            mgl = mbIbuCalc.tinsethMgl(updatedScope.hops[i].weight, updatedScope.hops[i].aa, updatedScope.boilVolume);
                            ibu = mbIbuCalc.tinsethIbu(utilisation, mgl);
                            
                            // update hop scope with values
                            updatedScope.hops[i].utilisation = utilisation.toFixed(2);
                            updatedScope.hops[i].mgl = mgl.toFixed(2);
                            updatedScope.hops[i].ibu = ibu.toFixed(2);

                            // update scope with total ibu
                            totalibu += ibu;
                        }
                    }

                    updatedScope.ibu = totalibu.toFixed(2);
                };

                // setup listeners
                scope.$watch('hops', performCalc, true);
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
    directive('mbProgress', function ($document, $window, $rootScope, progressbar) {
        return {
           restrict: 'EA',
           link: function (scope, elem, attrs) {
           }
        }
    });