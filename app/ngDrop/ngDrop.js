angular.module('ngDrop', [])
	.directive('dropdown', function($document){
		return {
			restrict: "E",
			transclude: true,
			template: 
			   "<div class='dropdown'><div ng-click='show = !show' class='dropdown-selector' ng-class='{glow: show}'> \
						<span ng-class='{grayed: !dropdownModel}'>{{dropdownPlaceholder}}</span> \
						<div class='arrow-down'></div>\
					</div> \
				<div ng-show='show' class='dropdown-wrapper'> \
					<search search-model='searchText' class='searchbox' placeholder='find item'></search> \
					<ul class='box' ng-transclude></ul> \
				</div></div>",
			scope: {
				dropdownModel: "=",
				dropdownPlaceholder: '@'
			},
			controller: function($scope){
				$scope.show = false;
				this.setModel = function(model, value){
					$scope.dropdownModel = model;
					$scope.dropdownPlaceholder = value;
					$scope.show = false;
					$scope.searchText = '';
				};
			},
			link: function(scope, element, attrs){
				element.bind('click', function(e){
					e.stopPropagation();
				});

				scope.$watch('searchText', function(text){
					if (text !== undefined){
						angular.forEach(element.find('dropdown-group'), function(value){
							var is_group = true;
							angular.forEach(angular.element(value).find('dropdown-item'), function(item){
								itemSpan = angular.element(item).find('span')[0]; 
								itemHtml = itemSpan.innerHTML;
								itemHtml = itemHtml.replace('<b>','').replace('</b>','');
								var i = itemHtml.toLowerCase().indexOf(text.toLowerCase());
								if (text !== '' && i === -1){
									item.hidden = true;
								} else {
									item.hidden = false;
									itemSpan.innerHTML = itemHtml.substring(0,i) + "<b>" + itemHtml.substring(i,i+text.length)+ "</b>" + itemHtml.substring(i+text.length);
									is_group = false;
								}
							});
							value.hidden = is_group;
						});	
					}
				});

				$document.bind('click', function(event){
					scope.show = false;
					scope.$apply();
				});
			}
		};
	})

	.directive('dropdownGroup', function(){
		return {
			restrict: "E",
			transclude: true,
			template: "<li class='group'><div class='group-name'>{{name}}</div><ul class='group-list'ng-transclude></ul></li>",
			scope: {
				name: "@"
			}
		};
	})

	.directive('dropdownItem', function(){
		return {
			restrict: "E",
			transclude: true,
			require: "^dropdown",
			template: "<li class='item' ng-transclude ng-click='setValue()'></li>",
			scope: {
				model: "="
			},
			link: function(scope, elem, attrs, dropdown){
				scope.setValue = function(){
					try {
						console.log('Hello?');
						console.log(attrs);
						console.log(scope);
					} catch(e) {
						console.log(e);
					}
					dropdown.setModel(scope.model, elem.text());
				};
			},
		};
	})
	.directive('search', function(){
		return {
			restrict: "E",
			scope: {
				placeholder: "@",
				searchModel: "="
			},
			template:
			'<div class="search">'+
			'   <div class="search-icon"></div>'+
			'   <input class="search-input" type="text" ng-model="searchModel" placeholder="{{placeholder}}" />'+
			'</div>',
		};
	});