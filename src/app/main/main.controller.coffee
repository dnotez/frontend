angular.module "dNotz"
.controller "MainCtrl", ($scope, Restangular) ->
  $scope.articles = [
  ]
  Restangular.allUrl 'articles', '/api/articles'
  .getList {pageSize: 20}
  .then (articles) ->
    #if true then return
    $scope.articles.length = 0
    seg = row = col = 0
    for article in articles
      article.col = col
      article.row = row
      if article.item.body.length > 300
        if article.item.body.length > 500
          article.item.longText = true
          article.item.fullText = article.item.body
          article.item.body = article.item.body.substring(0, 500)
        article.sizeX = 3
        article.sizeY = 2
        row += 2
        seg += 3
        col += 3
      else if article.item.body.length > 100
        article.sizeX = 3
        article.sizeY = 1
        seg += 3
        col += 3
      else if article.item.body.length > 20
        article.sizeX = 2
        article.sizeY = 1
        seg += 2
        col += 2
      else
        article.sizeX = 1
        article.sizeY = 1
        seg += 1
        col += 1
      console.log 'col:', article.col, ', row:', article.row, ', sizeX:', article.sizeX, ', seg:', seg
      $scope.articles.push article
      if seg % 6 == 0
        col = 0
        row += 1
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
