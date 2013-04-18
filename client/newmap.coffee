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
    groups = [{x: 0, y:0}]
    # I have to check and make sure the data is ready. 
    if not dataset
      return

    drag = d3.behavior.drag()
              .origin(Object)
              .on("drag", (d) ->
                console.log(d)
                d.x = d3.event.x
                d.y = d3.event.y
                draw()
              )


    draw = ->
      group = d3.select("g").data(groups)
      group.call(drag)
      group.attr "transform", (d) ->
        "translate(#{d.x}, #{d.y})"

      # Add all of the squares
      group.selectAll("rect").data(dataset).enter().append("rect")
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
                    # .call(d3.behavior.drag().origin(Object).on("drag", dragaction))

    draw()
