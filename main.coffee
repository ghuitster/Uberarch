# Set up a database that can be accessed from the client,
# or from the server and put it in the global namespace #
exports = this
Artifacts = new Meteor.Collection("artifacts")
exports.Artifacts = Artifacts

# Global convenience functions #
getDataFromForm = (formID)->
  retobj = {}
  $("#{formID} > *").each ->
    field = $(@)
    if !!field.val() and field.val() isnt "Filter by Type"
      retobj[field.attr('id')] = field.val()
  return retobj
#

if Meteor.isClient

  # Set up some defauilts #
  Meteor.startup ->
    Session.set "current_page", 'home'
    Session.set "filter_criteria", {}
  #

  # These functions are needed to render the templates correctly. #
  Template.home.rendermap = ->
    Meteor.defer -> #This line is VERY important!
      loadmap()

  Template.layout.runlayoutscripts = ->
    $(document).foundation()
    return
  #

  # These are global helpers for all of the pages. #
  Handlebars.registerHelper "iscurrentpage", (page) ->
    return page is Session.get "current_page"

  Handlebars.registerHelper "getcurrentpage", (page) ->
    return Session.get "current_page"
  #

  # Code for the add artifacts page. #
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
  #

  # Searching artifacts. #
  searchFromMap = (context, page) ->
    Northing = context.params._northing
    Easting = context.params._easting
    NandE = {Northing: Northing, Easting: Easting}
    Session.set 'filter_criteria', NandE
    Session.set 'search_preset', NandE

  Template.artifact_search.artifacts = ->
    criteria = Session.get 'filter_criteria'
    regexes = {}
    for key, value of criteria
      regexes[key] = new RegExp ".*#{criteria[key]}.*", "i"
    console.log Artifacts.find(regexes).fetch()
    Artifacts.find(regexes)

  Template.artifact_search.events "click button#search" : ->
    criteria = getDataFromForm("#searchform")
    Session.set 'filter_criteria', criteria

  Template.artifact_search.events "click button#clear" : ->
    $('input').each ->
      

  Template.artifact_search.has_search_preset = ->
    if Session.get('search_preset')
      return true

  Template.artifact_search.get_search_preset = (NorE) ->
    preset = Session.get('search_preset')
    if NorE is 'northing'
      return preset['Northing']
    else
      return preset['Easting']
  #

  # Code for view teams page #
  Template.view_teams.makeflickable = ->
    Meteor.defer ->
      Flickable('.flickable', enableMouseEvents: true)
      return
  #

  # Set up page forwarding #
  Meteor.pages
    # Page values can be an object of options, a function or a template name string
    "/":
      to: "home"
      nav: "Home"

    "/home":
      to: "home"
      nav: "Home"

    "/add_artifact":
      to: "add_artifact"
      nav: "Add Artifact"

    "/artifact_search":
      to: "artifact_search"
      nav: "Artifact Search"

    "/artifact_search/:_northing/:_easting":
      to: "artifact_search"
      nav: "Artifact Search"
      before: searchFromMap

    "/view_action":
      to: "view_action"
      nav: "Action Log"

    "/view_teams":
      to: "view_teams"
      nav: "View Teams"
  ,
    # optional options to pass to the PageRouter
    defaults:
      layout: "layout"
