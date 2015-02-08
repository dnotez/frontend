angular.module "dNotez"
.controller "NoteCtrl", ['$scope','$stateParams', 'Restangular', ($scope, $stateParams, Restangular) ->
  noteId = $stateParams.noteId
  Restangular.one 'notes', noteId
  .get()
  .then (note) ->
    $scope.note = note.resource
    return
  return
]
