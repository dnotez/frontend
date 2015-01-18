describe 'StripPacker tests', ->
  beforeEach module 'strip-packer'

  stripPacker = {}
  beforeEach inject (_StripPacker_) ->
    stripPacker = _StripPacker_
    return

  it 'should return array for empty data', ->
    expect(stripPacker.pack).toBeDefined()
    expect(stripPacker.pack([])).toBeArray()

  verifyResult = (result, expectedSize, colsArray, rowsArray) ->
    expect(result).toBeArray()
    expect(result.length).toBe(expectedSize)
    expect(colsArray.length).toBe(result.length)
    expect(rowsArray.length).toBe(result.length)
    for note, i in result
      expect(note).toBeDefined()
      expect(note.col).toBeDefined()
      expect(note.row).toBeDefined()
      if note.col != colsArray[i]
        console.error('col[' + i + ']=' + note.col + ", must be " + colsArray[i]);
      expect(note.col).toBe(colsArray[i])
      if note.row != rowsArray[i]
        console.error('row[' + i + ']=' + note.row + ", must be " + rowsArray[i]);
      expect(note.row).toBe(rowsArray[i])
    return

  it 'should add col and row to the input array', ->
    packed = stripPacker.pack([{}])
    verifyResult(packed, 1, [0], [0])
    return

  it 'should pack variable length large rects correctly', ->
    for size in [0..5]
      #create test rects
      rects = []
      cols = []
      rows = []
      n = 0
      while n < size
        rects.push {sizeX: 3, sizeY: 1}
        cols.push n * 3 % 6
        rows.push Math.floor(n * 3 / 6)
        n++
      packed = stripPacker.pack(rects)
      verifyResult(packed, size, cols, rows)
    return

  it 'should pack variable length medium rects correctly', ->
    for size in [0..5]
      #create test rects
      rects = []
      cols = []
      rows = []
      n = 0
      while n < size
        rects.push {sizeX: 2, sizeY: 1, n: n}
        cols.push n * 2 % 6
        rows.push Math.floor(n * 2 / 6)
        n++
      packed = stripPacker.pack(rects)
      verifyResult(packed, size, cols, rows)
    return

  it 'should pack m,l rects in one row', ->
    rects = [
      {sizeX: 2, sizeY: 1}
      {sizeX: 3, sizeY: 2}
    ]
    verifyResult(stripPacker.pack(rects), 2, [0, 2], [0, 0])
    verifyResult(stripPacker.pack(rects.reverse()), 2, [0, 3], [0, 0])
    return

  it 'should pack m,l,m rects in one row', ->
    rects = [
      {sizeX: 2, sizeY: 1}
      {sizeX: 3, sizeY: 2}
      {sizeX: 2, sizeY: 1}
    ]
    packed = stripPacker.pack(rects)
    verifyResult(packed, 3, [0, 3, 0], [0, 0, 1])
    return

  it 'should pack repeating m,l,m rects correctly', ->
    for size in [0..5]
      #create test rects
      rects = []
      cols = []
      rows = []
      n = 0
      while n < size
        rects.push {sizeX: 2, sizeY: 1, n: 3 * n}
        cols.push 0
        rows.push n * 2
        rects.push {sizeX: 3, sizeY: 2, n: 3 * n + 1}
        cols.push 3
        rows.push n * 2
        rects.push {sizeX: 2, sizeY: 1, n: 3 * n + 2}
        cols.push 0
        rows.push n * 2 + 1
        n++
      packed = stripPacker.pack(rects)
      verifyResult(packed, 3 * size, cols, rows)
    return

  it 'should pack m,m,l rects in one row', ->
    rects = [
      {sizeX: 2, sizeY: 1}
      {sizeX: 2, sizeY: 1}
      {sizeX: 3, sizeY: 2}
    ]
    verifyResult(stripPacker.pack(rects), 3, [0, 0, 3], [0, 1, 0])
    return

  it 'should pack repeating m,m,l rects correctly', ->
    for size in [0..5]
      rects = []
      cols = []
      rows = []
      n = 0
      while n < size
        rects.push {sizeX: 2, sizeY: 1, n: 3 * n}
        cols.push 0
        rows.push n * 2
        rects.push {sizeX: 2, sizeY: 1, n: 3 * n + 1}
        cols.push 0
        rows.push n * 2 + 1
        rects.push {sizeX: 3, sizeY: 2, n: 3 * n + 2}
        cols.push 3
        rows.push n * 2
        n++
      packed = stripPacker.pack(rects)
      verifyResult(packed, 3 * size, cols, rows)
    return

  it 'should pack l,m,m rects in one row', ->
    rects = [
      {sizeX: 3, sizeY: 2}
      {sizeX: 2, sizeY: 1}
      {sizeX: 2, sizeY: 1}
    ]
    verifyResult(stripPacker.pack(rects), 3, [0, 3, 3], [0, 0, 1])
    return

  it 'should pack repeating l,m,m rects correctly', ->
    for size in [0..5]
      rects = []
      cols = []
      rows = []
      n = 0
      while n < size
        rects.push {sizeX: 3, sizeY: 2, n: 3 * n}
        cols.push 0
        rows.push n * 2
        rects.push {sizeX: 2, sizeY: 1, n: 3 * n + 1}
        cols.push 3
        rows.push n * 2
        rects.push {sizeX: 2, sizeY: 1, n: 3 * n + 2}
        cols.push 3
        rows.push n * 2 + 1
        n++
      packed = stripPacker.pack(rects)
      verifyResult(packed, 3 * size, cols, rows)
    return

  it 'should pack l,m,l rects in two rows', ->
    rects = [
      {sizeX: 3, sizeY: 2}
      {sizeX: 2, sizeY: 1}
      {sizeX: 3, sizeY: 2}
    ]
    verifyResult(stripPacker.pack(rects), 3, [0, 3, 0], [0, 0, 2])
    return

  it 'should pack random size rects correctly#1', ->
    # 4l+4m+l+m
    rects = [
      {sizeX: 3, sizeY: 2}
      {sizeX: 3, sizeY: 2}
      {sizeX: 3, sizeY: 2}
      {sizeX: 3, sizeY: 2}
      {sizeX: 2, sizeY: 1}
      {sizeX: 2, sizeY: 1}
      {sizeX: 2, sizeY: 1}
      {sizeX: 2, sizeY: 1}
      {sizeX: 3, sizeY: 2}
      {sizeX: 2, sizeY: 1}
    ]
    verifyResult(stripPacker.pack(rects), 10, [0, 3, 0, 3, 0, 2, 4, 0, 3, 0], [0, 0, 2, 2, 4, 4, 4, 5, 5, 6])
    return

  it 'should pack random size rects correctly#2', ->
    # 1m+5l+4m
    rects = [
      {sizeX: 2, sizeY: 1, n: 0}
      {sizeX: 3, sizeY: 2, n: 1}
      {sizeX: 3, sizeY: 2, n: 2}
      {sizeX: 3, sizeY: 2, n: 3}
      {sizeX: 3, sizeY: 2, n: 4}
      {sizeX: 3, sizeY: 2, n: 5}
      {sizeX: 2, sizeY: 1, n: 6}
      {sizeX: 2, sizeY: 1, n: 7}
      {sizeX: 2, sizeY: 1, n: 8}
      {sizeX: 2, sizeY: 1, n: 9}
    ]
    verifyResult(stripPacker.pack(rects), 10, [0, 3, 0, 3, 0, 3, 0, 2, 4, 0], [0, 0, 2, 2, 4, 4, 6, 6, 6, 7])
    return

  return
