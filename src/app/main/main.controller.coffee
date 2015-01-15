angular.module "dNotez"
.controller "MainCtrl", ($scope, Restangular) ->
  $scope.notes = [
  ]

  ###
  simple best-fit layout algorithm:
  items = []
  for each note in notes
    dimension = calcArticleDimension(note)
    note.pos = findBestPosition(items, dimension)
    items.push(note)

  findBestPosition(items, dimension) :
    position = (0,0)
    for i in items

      if i.overlapWith(position, dimension)
        pos.x = i.x + i.w
        if pos.x >= MAX_WIDTH
          pos.y++

  ###
  $scope.layoutNotes = (notes) ->
    $scope.notes.length = 0
    items = []
    calculateArticleDimension = (note) ->
      if note.item.body.length > 300
        #fixthis: this has no effect on item array
        if note.item.body.length > 500
          note.item.longText = true
          note.item.fullText = note.item.body
          note.item.body = note.item.body.substring(0, 500)
        return [3, 2]
      else if note.item.body.length > 100
        return [3, 1]
      else if note.item.body.length > 20
        return [2, 1]
      else
        return [1, 1]

    # t stands for tile, move tile until find best position
    findBestPosition = (tw, th) ->
      tx = 0
      ty = 0
      j = 0
      i = 0
      console.log 'finding position, len=' + items.length
      while i < items.length
        xi = items[i].col
        yi = items[i].row
        wi = items[i].sizeX
        hi = items[i].sizeY
        console.log 'pos: i=' + i + ', j=' + j + ', (tx,ty)=' + tx + ',' + ty
        console.log 'item[' + i + '] (x,y)=' + xi + ',' + yi + ', [w,h]=' + wi + ',' + hi
        # X1+W1<X2 or X2+W2<X1 or Y1+H1<Y2 or Y2+H2<Y1
        if (tx + tw) <= xi or (xi + wi) <= tx or (ty + th) <= yi or (yi + hi) <= ty
          # no intersection
          console.log 'continue, no intersection'
          #return [tx, ty]
        else
          #move tile to the right edge of item i and check boundaries
          tx += wi
          console.log 'intersection, checking move to right ..., new tx=' + tx
          if (tx + tw) > 6 # passing right edge?
            console.log 'move to the begging of the next row, i=' + i + ', j=' + j
            #move back to the beginning of the row
            #move tile row to the bottom of the first tile in the row
            ty += 1
            tx = 0
            j = 0
            i -= (j + 2)
          else
            #increase number of passed items
            j++
        i++
      return [tx, ty]

    for note, index in notes
      dimension = calculateArticleDimension(note)
      note.sizeX = dimension[0]
      note.sizeY = dimension[1]
      position = findBestPosition(note.sizeX, note.sizeY)
      note.col = position[0]
      note.row = position[1]
      items.push note
      console.log 'note[' + index + ']:', note.item.title, 'body.len:' + note.item.body.length, 'dim:', dimension, 'pos:', position
      $scope.notes.push note
    return

  Restangular.allUrl 'notes', '/api/articles'
  .getList {pageSize: 20}
  .then (notes) ->
    $scope.layoutNotes(notes)

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

  $scope.customItems = [
    {size: {x: 2, y: 1}, position: [0, 0]},
    {size: {x: 2, y: 2}, position: [0, 2]},
    {size: {x: 1, y: 1}, position: [0, 4]},
    {size: {x: 1, y: 1}, position: [0, 5]},
    {size: {x: 2, y: 1}, position: [1, 0]},
    {size: {x: 1, y: 1}, position: [1, 4]},
    {size: {x: 1, y: 2}, position: [1, 5]},
    {size: {x: 1, y: 1}, position: [2, 0]},
    {size: {x: 2, y: 1}, position: [2, 1]},
    {size: {x: 1, y: 1}, position: [2, 3]},
    {size: {x: 1, y: 1}, position: [2, 4]}
  ]

  #map the gridsterItem to the custom item structure
  $scope.customItemMap = {
    sizeX: 'item.size.x',
    sizeY: 'item.size.y',
    row: 'item.position[0]',
    col: 'item.position[1]'
  }
