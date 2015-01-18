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

  /*
  describe('layout and position alignment', function () {
    var scope, MainCtrl;
    beforeEach(inject(function ($rootScope, $controller) {
      scope = $rootScope.$new();
      MainCtrl = $controller('MainCtrl', {
        $scope: scope
      });
    }));

    it('should works with empty list', inject(function () {
      expect(scope.layoutNotes).toBeDefined();
      expect(scope.layoutNotes).toBeFunction();
      expect(scope.notes).toBeDefined();
      expect(scope.notes).toBeArray();
      expect(scope.notes.length).toBe(0);
      scope.layoutNotes([]);
      expect(scope.notes.length).toBe(0);
    }));

    var textGenerator = function (textSize, fillChar) {
      return new Array(textSize).join(fillChar);
    };

    var resizeNote = function (index, newTextSize, fillChar, notes) {
      expect(index).toBeShorterThan(notes.length);
      notes[index].item.body = textGenerator(newTextSize, fillChar);
      return notes;
    };
    var notesGenerator = function (textSize, count, fillChar) {
      var notes = [];
      for (var i = 0; i < count; i++) {
        notes.push({
          item: {
            title: 'note#' + i,
            body: textGenerator(textSize, fillChar)
          }
        });
      }
      return notes;
    };

    var positionVerifier = function (notes, cols, rows) {
      expect(notes.length).toBe(cols.length);
      expect(notes.length).toBe(rows.length);
      for (var i = 0; i < notes.length; i++) {
        if (notes[i].col != cols[i]) {
          console.error('col[' + i + ']=' + notes[i].col + ", must be " + cols[i]);
          expect(notes[i].col).toBe(cols[i]);
        }
        if (notes[i].row != rows[i]) {
          console.error('row[' + i + ']=' + notes[i].row + ", must be " + rows[i]);
          expect(notes[i].row).toBe(rows[i]);
        }
      }
    };

    var dimensionVerifier = function (notes, widths, heights) {
      expect(notes.length).toBe(widths.length);
      expect(notes.length).toBe(heights.length);
      for (var i = 0; i < notes.length; i++) {
        expect(notes[i].sizeX).toBe(widths[i]);
        expect(notes[i].sizeY).toBe(heights[i]);
      }
    };

    it('should layout one big note in one row (6x2)', function () {
      console.log('one big');
      expect(scope.notes.length).toBe(0);
      scope.layoutNotes(notesGenerator(500, 1, '1'));
      expect(scope.notes.length).toBe(1);
      positionVerifier(scope.notes, [0], [0]);
      dimensionVerifier(scope.notes, [3], [2]);
    });

    it('should layout two big notes in one row (6x2)', function () {
      console.log('2 big');
      expect(scope.notes.length).toBe(0);
      scope.layoutNotes(notesGenerator(500, 2, '2'));
      expect(scope.notes.length).toBe(2);
      positionVerifier(scope.notes, [0, 3], [0, 0]);
      dimensionVerifier(scope.notes, [3, 3], [2, 2]);
    });

    it('should layout 3 big notes in two rows (6x4)', function () {
      console.log('3 big');
      expect(scope.notes.length).toBe(0);
      scope.layoutNotes(notesGenerator(500, 3, '3'));
      expect(scope.notes.length).toBe(3);
      positionVerifier(scope.notes, [0, 3, 0], [0, 0, 2]);
      dimensionVerifier(scope.notes, [3, 3, 3], [2, 2, 2]);
    });

    it('should layout 3 medium notes in one row (6x1)', function () {
      console.log('3 mediums');
      expect(scope.notes.length).toBe(0);
      scope.layoutNotes(notesGenerator(200, 3, '4'));
      expect(scope.notes.length).toBe(3);
      positionVerifier(scope.notes, [0, 3, 0], [0, 0, 1]);
      dimensionVerifier(scope.notes, [3, 3, 3], [1, 1, 1]);
    });

    it('should layout 10 small notes in 4 rows (6x4)', function () {
      console.log('smalls');
      expect(scope.notes.length).toBe(0);
      scope.layoutNotes(notesGenerator(30, 10, '5'));
      expect(scope.notes.length).toBe(10);
      positionVerifier(scope.notes, [0, 2, 4, 0, 2, 4, 0, 2, 4, 0], [0, 0, 0, 1, 1, 1, 2, 2, 2, 3]);
      dimensionVerifier(scope.notes, [2, 2, 2, 2, 2, 2, 2, 2, 2, 2], [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
    });

    it('should layout 4 notes (3S, 1L) in two rows (6x2)', function () {
      console.log('4 notes (3S, 1L)');
      expect(scope.notes.length).toBe(0);
      scope.layoutNotes(resizeNote(1, 400, '#', notesGenerator(30, 4, '6')));
      expect(scope.notes.length).toBe(4);
      positionVerifier(scope.notes, [0, 2, 0, 0], [0, 0, 1, 2]);
      dimensionVerifier(scope.notes, [2, 3, 2, 2], [1, 2, 1, 1]);
    });
  });
   */
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
