if Meteor.isClient

  Template.newmap.rendered = ->
    dataset = Artifacts.find({}).fetch()
    console.log(dataset)
    canvas = d3.select("#newmap")
    console.log("Here's the canvas element:")
    console.log(canvas)
    canvas.selectAll("circle").data(dataset).enter().append("circle")
    return
