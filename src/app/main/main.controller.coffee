angular.module "dNotez"
.controller "MainCtrl", ['$scope', 'Restangular', 'StripPacker', ($scope, Restangular, StripPacker) ->
  $scope.userNotes = {
    results: []
  }

  calcDimension = (note) ->
    if note.item.body.length > 300
      if note.item.body.length > 500
        note.item.longText = true
        note.item.fullText = note.item.body
        note.item.body = note.item.body.substring(0, 500)
      note.sizeX = 3
      note.sizeY = 2
    else
      note.sizeX = 2
      note.sizeY = 1

    return

  Restangular.all 'notes'
  .getList {pageSize: 20}
  .then (notes) ->
    for note,index in notes
      calcDimension(note)
    $scope.userNotes = StripPacker.pack(notes)

    return

  $scope.edit = (note) ->
    console.log 'editing note:'+note.item.id
    return

  $scope.remove = (note) ->
    Restangular.one('notes', note.item.id).remove().then () ->
      index = $scope.userNotes.indexOf note
      if index > -1
        $scope.userNotes.splice index, 1
        $scope.userNotes =  StripPacker.pack($scope.userNotes)
      return
    return

  $scope.gridsterOpts = {
    margins: [10, 10],
    outerMargin: true,
    pushing: true,
    floating: true,
    draggable: {
      enabled: false
    },
    resizable: {
      enabled: false,
      handles: ['n', 'e', 's', 'w', 'se', 'sw']
    }
  }
]
