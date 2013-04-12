### Set up a database that can be accessed from the client,
# or from the server and put it in the global namespace ###
exports = this
Artifacts = new Meteor.Collection("artifacts")
exports.Artifacts = Artifacts

### Set up page forwarding ###
if Meteor.isClient
  Meteor.pages
    # Page values can be an object of options, a function or a template name string
    "/":
      to: "home"
      as: "Home"

    "/home":
      to: "home"
      as: "Home"

    "/add_artifact":
      to: "add_artifact"
      as: "Add Artifact"

    "/artifact_search":
      to: "artifact_search"
      as: "Artifact Search"

    "/view_action":
      to: "view_action"
      as: "Action Log"

    "/view_teams":
      to: "view_teams"
      as: "View Teams"
  ,
    # optional options to pass to the PageRouter
    defaults:
      layout: "layout"

### Global convenience functions ###
getDataFromForm = (formID)->
  retobj = {}
  $("#{formID} > *").each ->
    field = $(@)
    retobj[field.attr('id')] = field.val()
  return retobj

######

if Meteor.isClient
  ### Set up some defauilts ###
  Meteor.startup ->
    Session.set "current_page", 'home'
    Session.set "filtered_artifacts", Artifacts.find({})
  ######

  ### These functions are needed to render the templates correctly. ###
  Template.home.rendermap = ->
    Meteor.defer -> #This line is VERY important!
      loadmap()

  Template.layout.runlayoutscripts = ->
    $(document).foundation()
    return ""
  ######

  ### These are global helpers for all of the pages. ###
  Handlebars.registerHelper "iscurrentpage", (page) ->
    return page is Session.get "current_page"

  Handlebars.registerHelper "getcurrentpage", (page) ->
    return Session.get "current_page"
  ######

  ### Code for the add artifacts page. ###
  Template.add_artifact.events "click button#add": ->
    Artifacts.insert (
      Northing: $("#Northing").val()
      Easting: $("#Easting").val()
      Datum : $("#Datum").val()
      Notes: $("#Notes").val()
      Username: $("#Username").val()
      ArtifactNumber: $("#ArtifactNumber").val()
      ArtifactType: $("#ArtifactType").val()
      Depth: $("#Depth").val()
    )
    $('<p>Data added!</p>').insertAfter('#add')
  ######

  ### Searching artifacts. ###
  Template.artifact_search.artifacts = ->
    Session.get('filtered_artifacts')

  Template.artifact_search.events "click button#search" : ->
    formdata=getDataFromForm("#searchform")

  Template.artifact_search.has_search_preset = ->
    if Session.get('search_preset')
      return true

  Template.artifact_search.get_search_preset = (NorE) ->
    preset = Session.get('search_preset')
    if NorE is 'northing'
      return preset['northing']
    else
      return preset['easting']
  ######

  ### Code for view teams page ###
  Template.view_teams.makeflickable = ->
    Meteor.defer ->
      Flickable('.flickable', enableMouseEvents: true)
      return ""
  ######