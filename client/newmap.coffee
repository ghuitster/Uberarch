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

    dragstart = (d)->
      $("#tiptip_holder").attr("id", "tiptip_holder_hidden")

    dragend = (d)->
      d3.select("#tiptip_holder_hidden").attr("id", "tiptip_holder")

    drag = d3.behavior.drag()
              .origin(Object)
              .on("drag", (d) ->
                d.x = d3.event.x
                d.y = d3.event.y
                draw()
              )
              .on("dragstart", dragstart)
              .on("dragend", dragend)

    over = (d) ->
      id = "#grid-#{d.row}#{d.col}"
      grid = d3.select(id)
      grid.attr "stroke-width", 2
      grid.attr "stroke", "#C54B2C"

    out = (d) ->
      id = "#grid-#{d.row}#{d.col}"
      grid = d3.select(id)
      grid.attr "stroke-width", 0.1 
      grid.attr "stroke", "black"

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
                    .attr("fill", "#11BAAC")
                    .attr("fill-opacity", (d) -> 0.1*d.count)
                    .attr("fill", "#222B6E")
                    .attr("fill-opacity", (d) -> 0.05*d.count)
                    .attr("stroke", "#141a29")
                    .attr("stroke-width", 0.1)
                    .attr("stroke-opacity", 1)
                    .attr("id", (d)-> "grid-#{d.row}#{d.col}")
                    .attr("title", (d)-> "<p>[#{d.row},#{d.col}]: Has #{d.count} artifact[s]</p><p>Tap for more info.</p>")
                    .classed("tip", true)
                    .attr("class", "tip")
                    .on("mouseover", over)
                    .on("mouseout", out)

      group.selectAll("text").data(dataset).enter().append("text")
                    .text((d)-> "#{d.row}, #{d.col}")
                    .attr("x", (d) -> d.x + 5)
                    .attr("y", (d) -> d.y + griddim - 5)
                    .attr("font-size", "8px")


    draw()
    $(".tip").tipTip({defaultPosition: "top", delay: 900, maxWidth: "#{griddim+20}px"})
