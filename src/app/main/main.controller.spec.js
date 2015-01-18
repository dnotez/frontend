'use strict';

describe('controllers', function () {
  beforeEach(function () {
    module('dNotez');
  });


  describe('initial state', function () {
    var scope;
    beforeEach(inject(function ($rootScope) {
      scope = $rootScope.$new();
    }));

    it('should have empty notes array', inject(function ($controller) {
      expect(scope.notes).toBeUndefined();

      $controller('MainCtrl', {
        $scope: scope
      });

      expect(scope.notes).toBeDefined();
      expect(scope.notes.length).toBe(0);
      expect(scope.notes).toBeArray();
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

    it('should get the mock notes via REST', inject(function () {
      expect(scope.notes).toBeDefined();
      /*
       //see https://github.com/mgonto/restangular/issues/98
       //see https://ath3nd.wordpress.com/2013/08/05/15/
       var notes = MainCtrl.notes;
       spyOn(Restangular, 'getList').andCallThrough();

       $httpBackend.whenGET('/api/notes', {pageSize:20}).respond([{title:'t1'}]);
       expect(Restangular.getList).toHaveBeenCalledWith('/api/notes');
       $httpBackend.flush();
       scope.notes.resolve();
       */
    }));
  });
});
