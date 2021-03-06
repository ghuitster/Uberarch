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

# Code for the add artifacts page. #
Template.add_artifact.getDBSize = ->
  DBEntryCount = Artifacts.find({}).count()
  return

Template.add_artifact.events "click button#add": ->
  $('.statusbox').text("Artifact number #{$("#ArtifactNumber").val()} added successfully by #{$("#Username").val()}")
  $('.statusbox').animate({height: 40, padding: 10})
  DBEntryCount += 1
  Artifacts.insert (
    Northing: $("#Northing").val()
    Easting: $("#Easting").val()
    Datum : $("#Datum").val()
    Notes: $("#Notes").val()
    Username: $("#Username").val()
    ArtifactNumber: $("#ArtifactNumber").val()
    ArtifactType: $("#ArtifactType").val()
    Depth: $("#Depth").val()
    DBNumber: DBEntryCount
  )
  clearForm()

Template.add_artifact.events "click button#clear" : ->
  clearForm()

clearForm = ->
  $('input, textarea').each ->
    field = $(@)
    field.val("")
    $("#ArtifactType").get(0).selectedIndex = 0
#


# Searching artifacts. #
searchFromMap = (context, page) ->
  Northing = context.params._northing
  Easting = context.params._easting
  NandE = {Northing: Northing, Easting: Easting}
  Session.set 'filter_criteria', NandE
  Session.set 'search_preset', NandE

Template.artifact_search.artifacts = ->
  Session.set 'statusmessage', ''
  criteria = Session.get 'filter_criteria'
  regexes = {}
  for key, value of criteria
    regexes[key] = new RegExp ".*#{criteria[key]}.*", "i"
  arts = Artifacts.find(regexes)
  if not arts.count()
    Session.set 'statusmessage', 'No artifacts found.'
  arts

Template.artifact_search.statusmessage = ->
  Session.get 'statusmessage'

Template.artifact_search.events "click button#search" : ->
  criteria = getDataFromForm("#searchform")
  Session.set 'filter_criteria', criteria

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

Template.artifact_search.events "click button#clear" : ->
  clearForm()
  criteria = getDataFromForm("#searchform")
  Session.set 'filter_criteria', criteria

# Action log #
Template.view_action.artifacts = ->
  Artifacts.find {}, {sort: {DBNumber: -1}, limit: 25}

# Set up page forwarding #
Meteor.pages
  # Page values can be an object of options, a function or a template name string
  "/":
    to: "newmap"
    nav: "Home"

  "/home":
    to: "newmap"
    nav: "Home"

  "/newmap":
    to: "newmap"
    nav: "Newmap"

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

