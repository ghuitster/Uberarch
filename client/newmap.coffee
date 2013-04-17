totaldim = 900
gridcount = 10
griddim = totaldim / gridcount
gridcenter = griddim / 2

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
    
    dragaction = (d) ->
      repositionx = () ->
        console.log this.x
        return this.x

      # draggables = d3.selectAll(".draggable")
      # console.log this
      # this.x += d3.event.x
      # this.x += d3.event.x
      yep = d3.select(this)
          .attr('x', repositionx)
          # .attr('y', repositiony)
      # draggables.attr('x', d3.event.x)
      # draggables.attr('y', d3.event.y)


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
                                                    .attr("class", "draggable")
                                                    .call(d3.behavior.drag().on("drag", dragaction))
                                                    # .on("click", () -> console.log("MOUSING OVER"))
    

    
  return
