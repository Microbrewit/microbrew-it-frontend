var app;

app = angular.module('Microbrewit', []);

app.config(['$routeProvider'], function($routeProvider) {
  return $routeProvider.when('/', {
    templateUrl: 'templates/home.html',
    controller: 'HomeCtrl'
  }).otherwise({
    redirectTo: '/'
  });
});

//# sourceMappingURL=../../tmp/js/app.js.map
