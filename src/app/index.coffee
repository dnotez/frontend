angular.module "dNotez", ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'restangular', 'ui.router',
                          'mm.foundation', 'gridster', 'angularMoment', 'strip-packer']
.config ($stateProvider, $urlRouterProvider) ->
  $stateProvider
  .state "home",
    url: "/",
    templateUrl: "app/main/main.html",
    controller: "MainCtrl"
  .state "profile",
    url: "/profile",
    templateUrl: "app/profile/profile.html",
    controller: "ProfileCtrl"
  .state "download",
    url: "/download",
    templateUrl: "download.html",
  .state "about",
    url: "/about",
    templateUrl: "about.html",

  $urlRouterProvider.otherwise '/'

