this.loadmap = ->
  paper = Raphael(document.getElementById('map'), 833, 401)

  # Variables:
  imgdim= 900
  cellcount = 10
  cellwidth = imgdim / cellcount
  movegroup = []
  
  # Functions:
  makesquare = (row, col, dim) ->
      x = row*dim
      y = col*dim
      square = paper.rect(x, y, dim, dim)
      square.row = row
      square.col = col
      square.attr "fill", "#000"
      square.attr "fill-opacity", "0"
      square.attr "stroke", "#000"
      square.attr "opacity", "0.5"
      textpadding = 3
      text = paper.text(x+textpadding, y+dim-5-textpadding, row+", "+col)
      text.attr "text-anchor", "start"
      text.attr "fill", "#000"
      text.attr "font-size", "14"
      text.attr "opacity", "0.75"
      movegroup.push square
      movegroup.push text
      return square

    # Draggable functions:
    start = () ->
      for item in movegroup
        item.ox = item.attr("x")
        item.oy = item.attr("y")

    move = (dx, dy) ->
      for item in movegroup
        item.attr {x: item.ox + dx, y: item.oy + dy}

    # Click callback:
    clickedhandler = ()->
      console.log "Clicked: "+@row+" "+@col
      parent.location = ("/artifact_search/#{@row}/#{@col}")
      
  #Logic:
  image = paper.image("/mapsmall.jpg", 0, 0, imgdim, imgdim)
  movegroup.push image
  for row in [0..cellcount-1]
    for col in [0..cellcount-1]
      cell = makesquare(row, col, cellwidth)
      cell.dblclick(clickedhandler)
      cell.drag(move, start, null)
