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
    directive('mbCalcColour', function(mbIbuCalc) {
        return {
            restrict: 'A',
            scope: 'isolate',
            template: '<div class="colour">{{colour}} {{unit}}</div>',
            replace: true,
            link: function (scope, element, attr) {
                function calc (weight, volume, lovibond, unit) {
                    if(weight && weight != "" && volume && volume != "" && lovibond && lovibond != "") {
                        var colour = mbIbuCalc.morey(weight, volume, lovibond);

                        if(unit == "ebc") {
                            var colour = mbIbuCalc.srmToEbc(colour);
                        }

                        return colour;
                    } else {
                        return 'undefined';
                    }
                }

                attr.$observe('unit', function (unit) {
                    scope.colour = calc(attr.weight, attr.volume, attr.lovibond, unit);
                });
                attr.$observe('weight', function (weight) {
                    scope.colour = calc(weight, attr.volume, attr.lovibond, attr.unit);
                });
                attr.$observe('volume', function (volume) {
                    scope.colour = calc(attr.weight, volume, attr.lovibond, attr.unit);
                });
                attr.$observe('lovibond', function (lovibond) {
                    scope.colour = calc(attr.weight, attr.volume, lovibond, attr.unit);
                });
            }
        }
    }).
    directive('mbColour', function() {
        return {
            restrict: 'E',
            template: '<li><input class="two columns no-padding offset-right-by-one" /><input class="ten columns no-padding offset-right-by-one" /><input class="two columns no-padding" /></li>',
            link: function (scope, element, attr) {
                $('.add', $(element).on('click', function () {
                    scope.malts.push({ name: "", lovibond: 0, weight: 0 });
                }));
            }
        }
    }).
	directive('mbCalcBitterness', function(mbcalc) {
    //weight, alphaAcid, batchSize, og, boilTime
		return {
    		restrict: 'EA',
    		scope: 'isolate',
    		template: '<div class="bitterness">{{bitterness}} {{unit}}</div>',
    		link: function (scope, element, attr) {
    			var unitToUse = "IBU";

    			function calcBitterness(og, fg) {
    				if(formulaToUse == "tinseth") {
    					return mbcalc.ibuTinseth(og, fg);
    				}
    				if(formulaToUse == "rager") {
    					return mbcalc.ibuRager(og, fg);
    				}
    				if(formulaToUse == "garetz") {
    					return mbcalc.ibuGaretz(og,fg);
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
	});