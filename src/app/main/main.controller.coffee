angular.module "dNotez"
.controller "MainCtrl", ['$scope', 'Restangular', 'StripPacker', ($scope, Restangular, StripPacker) ->
  $scope.notes = [
  ]

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

  Restangular.allUrl 'notes', '/api/articles'
  .getList {pageSize: 20}
  .then (notes) ->
    for note,index in notes
      calcDimension(note)
      console.log index + ': [w,h] =' + note.sizeX + ',' + note.sizeY
    $scope.notes = StripPacker.pack(notes)
    return

  $scope.gridsterOpts = {
    margins: [20, 20],
    outerMargin: false,
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
