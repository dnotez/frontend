'use strict';

describe('controllers', function () {
  beforeEach(module('dNotz'));


  describe('initial state', function () {
    var scope;
    beforeEach(inject(function ($rootScope) {
      scope = $rootScope.$new();
    }));

    it('should have empty articles array', inject(function ($controller) {
      expect(scope.articles).toBeUndefined();

      $controller('MainCtrl', {
        $scope: scope
      });

      expect(scope.articles).toBeDefined();
      expect(scope.articles.length).toBe(0);
      expect(scope.articles).toBeArray();
    }));

  });

  describe('backend communication', function () {
    var scope, $httpBackend, MainCtrl, Restangular;
    beforeEach(inject(function ($rootScope, $controller, _$httpBackend_, _Restangular_) {
      scope = $rootScope.$new();
      $httpBackend = _$httpBackend_;
      Restangular = _Restangular_;
      MainCtrl = $controller('MainCtrl', {
        $scope: scope
      });
    }));

    it('should get the mock articles via REST', inject(function () {
      expect(scope.articles).toBeDefined();
      /*
       //see https://github.com/mgonto/restangular/issues/98
       //see https://ath3nd.wordpress.com/2013/08/05/15/
       var articles = MainCtrl.articles;
       spyOn(Restangular, 'getList').andCallThrough();

       $httpBackend.whenGET('/api/articles', {pageSize:20}).respond([{title:'t1'}]);
       expect(Restangular.getList).toHaveBeenCalledWith('/api/articles');
       $httpBackend.flush();
       scope.articles.resolve();
       */
    }));
  });
});
