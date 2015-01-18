###
  Simplified version of 2d strip packing. Try to pack rectangles into a strip of width 6 and unlimited height
  Assumption: We only have medium (m, width=2) and large (l, width=3) rectangles.

###
angular.module 'strip-packer', []
.factory 'StripPacker', ->
  {
  pack: (cells)->
    #console.log 'packing array of cells with length:' + cells.length
    stack = []
    row = 0
    curRowSum = 0

    doLayout = () ->
      #align all cells in one row and return maximum height of the cells
      alignInOneRow = () ->
        maxHeight = 0
        while stack.length > 0
          c = stack.pop()
          c.row = row
          c.col = curRowSum - c.sizeX
          curRowSum -= c.sizeX
          if (c.sizeY > maxHeight)
            maxHeight = c.sizeY
        return maxHeight


      if stack.length < 3
        row += alignInOneRow()
      else
        c3 = stack.pop()
        c2 = stack.pop()
        c1 = stack.pop()
        if c1.sizeX == c2.sizeX == c3.sizeX
          stack.push c1
          stack.push c2
          stack.push c3
          row += alignInOneRow()
          return

        #different width cases
        switch c2.sizeX
          when 3 #c2 is large, assuming c2 height is 2
            switch c3.sizeX
              when 3 #m,l,l case, c1 must be size of 2, stretch c1 to 3, put c1 and c2 in one row and push c3 for next checking round
                c1.sizeX = 3
                curRowSum = 6 #one expanded medium and one large
                stack.push c1
                stack.push c2
                row += alignInOneRow()
                stack.push c3
                curRowSum = c3.sizeX
              when 2 #m,l,m pack c1,c2 and c3 in one row
              #console.log 'packing in one row m(c1:' + c1.sizeX + '),l(c2:' + c2.sizeX + '),m(c3:' + c3.sizeX + ')'
                c1.sizeX = 3 # stretch c1 to fit
                curRowSum -= 1 #because we stretched c1
                stack.push c1
                stack.push c2
                row += alignInOneRow() #put c1(m) and c2(l) in one row
                c3.sizeX = 3 # stretch medium to fit
                c3.col = c1.col # left align c1 and c3
                c3.row = c1.row + c1.sizeY # put c3 under c1
                curRowSum = 0 #this row is done
              else
                console.log 'unsupported width (c2 is large), c3=' + c3.sizeX
          when 2 #c2 is medium
            switch c3.sizeX
              when 2 #l,m,m case, pack in one row
                c2.sizeX = 3 # stretch c2 to fit
                curRowSum -= 1 #because we stretched c2
                stack.push c1
                stack.push c2
                row += alignInOneRow() #put c1(l) and c2(m) in one row
                c3.sizeX = 3 # stretch medium to fit
                c3.col = c2.col # left align c1 and c2
                c3.row = c2.row + c2.sizeY # put c3 under c2
                curRowSum = 0 #this row is done
              when 3 #m,m,l or l,m,l case
                if c1.sizeX is 2 # m,m,l case, put two medium cells on one column and pack all 3 in one row
                  c1.sizeX = c2.sizeX = 3
                  curRowSum -= 1
                  stack.push c1 #try to not change the order too much, keep c1 in column 0
                  stack.push c3
                  row += alignInOneRow() #put c1(m) and c3(l) in one row
                  c2.col = c1.col #align c1 and c2
                  c2.row = c1.row + c1.sizeY #put c2 under c1
                  curRowSum = 0 #this row is done
                else
                  c2.sizeX = 3
                  curRowSum = c1.sizeX + c2.sizeX
                  stack.push c1
                  stack.push c2
                  row += alignInOneRow()
                  curRowSum = c3.sizeX
                  stack.push c3
              else
                console.log 'unsupported width (c2 is medium), c3=' + c3.sizeX
          else
            console.log 'unsupported width, c2=' + c3.sizeX + ', stack:' + stack + ', cells:', cells
      return

    for c in cells
      #verify and initialise rect
      if !angular.isDefined(c.sizeX)
        c.sizeX = 0
      if !angular.isDefined(c.sizeY)
        c.sizeY = 0
      c.row = row
      c.col = 0

      stack.push c
      curRowSum += c.sizeX
      if curRowSum >= 6
        doLayout()
    if stack.length > 0
      doLayout()

    return cells
  }
