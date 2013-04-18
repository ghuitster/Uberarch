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
                d.x = d3.event.x
                d.y = d3.event.y
                $("#tiptip_holder").css("display", "none")
                draw()
              )

    over = (d) ->
      id = "#grid-#{d.row}#{d.col}"
      grid = d3.select(id)
              .transition()
              .attr("stroke-width", 2)
              .attr("stroke", "#C54B2C")

    out = (d) ->
      id = "#grid-#{d.row}#{d.col}"
      grid = d3.select(id)
              .transition()
              .attr("stroke-width", 0.1)
              .attr("stroke", "black")

    clicked = (d) ->
      parent.location = ("/artifact_search/#{d.row}/#{d.col}")

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
                    .on("click", clicked)

      group.selectAll("text").data(dataset).enter().append("text")
                    .text((d)-> "#{d.row}, #{d.col}")
                    .attr("x", (d) -> d.x + 5)
                    .attr("y", (d) -> d.y + griddim - 5)
                    .attr("font-size", "8px")


    draw()
    $(".tip").tipTip({defaultPosition: "top", delay: 400, maxWidth: "#{griddim+20}px"})
