###
  Simplified version of 2d strip packing. Try to pack rectangles into a strip of width 6 and unlimited height
  Assumption: We only have medium (m, width=2) and large (l, width=3) rectangles.

###
angular.module 'strip-packer', []
.factory 'StripPacker', ->
  {
  pack: (rects)->
    i = 0
    row = 0
    sumCol = 0
    maxSizeY = -1
    checkBoundaries = (index) ->
      if (sumCol >= 5)
        console.log 'sumCol:' + sumCol + ', index=' + index
        switch sumCol
          when 6
            row += maxSizeY
            sumCol = 0
            maxSizeY = 0
          when 5 #check sizeX of the current note
            switch rects[index].sizeX
              when 2 #"1,m | m" or "m,l | m"
              #console.log '"1,m | m" or "m,l | m"'
                rects[index].sizeX = 3 #fit the row
                switch rects[index - 1].sizeX
                  when 2 # previous rect is medium, l,m,m
                    rects[index].col = rects[index - 1].col
                    rects[index].row = rects[index - 1].row + rects[index - 1].sizeY
                    rects[index - 1].sizeX = 3
                    row = rects[index].row
                    sumCol = rects[index].col
                    maxSizeY = 0
                #console.log '> l,m,m >>>  case ==>>> current['+index+'] =', rects[index], 'prevLarge =', rects[index - 1]
                #console.log '> l,m,m >>>  case ==>>> rects = ', rects, ', r['+index+']=', rects[index]
                  when 3 # previous rect is large m,l,m
                    rects[index].col = rects[index - 2].col
                    rects[index].row = rects[index - 2].row + rects[index - 2].sizeY
                    rects[index - 2].sizeX = 3
                    rects[index - 1].col = 3 # adjust large rect col
                    console.log '>>>> m,l,m case ==>>> current[' + index + '] =', rects[index], 'prevLarge =', rects[index - 1]
                    console.log '>>>> rects = ', rects, ', r[' + index + ']=', rects[index]
                    row = rects[index].row
                    sumCol = 0
                    maxSizeY = 0
              when 3 #"l,m | l" or "m,l | l"
              #console.log '"l,m | l" or "m,l | l" ==>>> current['+index+'] =', rects[index]
              #l,m,l -> l,l & i-- & continue
              #m,l,l -> swap with current l & i-- & continue
              else
                console.log('unsupported width, note[' + index + ']:', rects[index])
          when 7 #m,m,l
          #console.log('777 ==>> "m,m | l"')
            rects[index].col = 3
            rects[index - 1].col = 0
            rects[index - 1].row = rects[index - 2].row + rects[index - 2].sizeY
            #expand width of two mediums to 3
            rects[index - 1].sizeX = 3
            rects[index - 2].sizeX = 3
      return
    while (i < rects.length)
      checkBoundaries i
      rects[i].row = row
      rects[i].col = sumCol
      console.log 'i=' + i + ', sumCol=' + sumCol
      sumCol += rects[i].sizeX
      if rects[i].sizeY > maxSizeY
        maxSizeY = rects[i].sizeY
      i++
    if rects.length > 2
      checkBoundaries rects.length - 1
    return rects
  }
