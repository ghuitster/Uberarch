totaldim = 900
gridcount = 10
griddim = totaldim / gridcount
gridcenter = griddim / 2
groupxoffset = 0
groupyoffset = 0

#---------------------- Methods
builddata = ->
  if not Artifacts.find({}).count()
    return null
  finaldata = []
  for row in [0..gridcount - 1]
    for col in [0..gridcount - 1]
      artcount = Artifacts.find({Northing: "#{row}", Easting: "#{col}"}).count()
      cell = {row: row, col: col, count: artcount, x: row*griddim, y: col*griddim}
      finaldata.push cell
  return finaldata

#---------------------- Helpers and events
Template.newmap.rendered = ->
  Deps.autorun ->
    
    dataset = builddata()
    # I have to check and make sure the data is ready. Otherwise the drawing
    # code only runs once. I'm guessing this is because D3 has optimization built in.
    if not dataset
      return
    canvas = d3.select("g")
    canvas.call(d3.behavior.drag().on("drag", dragmove))
    
    dragmove = (d) ->
      console.log d3.event.x
      console.log d3.event.y
      groupxoffset += d3.event.dx
      groupyoffset += d3.event.dy
      canvas.attr("transform", "translate(#{groupxoffset},#{groupyoffset})")


    # Add all of the squares
    canvas.selectAll("rect").data(dataset).enter().append("rect")
                                                    .attr("x", (d) -> d.x)
                                                    .attr("y", (d) -> d.y)
                                                    .attr("width", griddim)
                                                    .attr("height", griddim)
                                                    .attr("fill", "#2e3c60")
                                                    .attr("fill-opacity", (d) -> 0.1*d.count)
                                                    .attr("stroke", "#141a29")
                                                    .attr("stroke-width", 0.1)
                                                    .attr("stroke-opacity", 1)
    

    
  return
