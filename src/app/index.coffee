angular.module "dNotez", ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'restangular', 'ui.router',
                          'mm.foundation', 'gridster', 'angularMoment', 'strip-packer']
.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
  .state "home",
    url: "/",
    templateUrl: "app/main/main.html",
    controller: "MainCtrl"

  $urlRouterProvider.otherwise '/'

