### Set some defaults, and establish a database. ###
Artifacts = new Meteor.Collection("artifacts")
Session.set "current_page", 'home'
######

### Global convenience functions ###
getDataFromForm = (formID)->
  retobj = {}
  $("#{formID} > *").each ->
    field = $(@)
    retobj[field.attr('id')] = field.val()
  return retobj

######

### These functions are needed to render the templates correctly. ###
Template.home.rendermap = ->
  Meteor.defer -> #This line is VERY important!
    document.loadmap()

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

Template.add_artifact.events "click button#random": ->
  ## Helpful functions
  getRandomInt = (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  createRandomWord = (length) ->
    consonants = "bcdfghjklmnpqrstvwxyz"
    vowels = "aeiou"
    rand = (limit) ->
      Math.floor Math.random() * limit

    i = undefined
    word = ""
    length = parseInt(length, 10)
    consonants = consonants.split("")
    vowels = vowels.split("")
    i = 0
    while i < length / 2
      randConsonant = consonants[rand(consonants.length)]
      randVowel = vowels[rand(vowels.length)]
      word += (if (i is 0) then randConsonant.toUpperCase() else randConsonant)
      word += (if i * 2 < length - 1 then randVowel else "")
      i++
    word
  ##
  $("#NandE").val(getRandomInt(0, 9)+", "+getRandomInt(0, 9))
  $("#Datum").val(0)
  $("#Notes").val(createRandomWord(5) + " " + createRandomWord(10))
  $("#Username").val(createRandomWord(7))
  $("#ArtifactNumber").val(getRandomInt(24587, 52804))
  $("#ArtifactType").get(0).selectedIndex = getRandomInt(1, 4)
  $("#Depth").val(getRandomInt(0, 8) + "." + getRandomInt(0, 9))



######

### Searching artifacts. ###
Template.artifact_search.artifacts = ->
  # Session.set('searched_artifacts', Artifacts.find({}))
  # return Session.get('searched_artifacts')
  Artifacts.find()

Template.artifact_search.events "click button#search" : ->
  formdata = getDataFromForm("#searchform")
  if formdata['ArtifactType'] is "Filter by Type"
    formdata['ArtifactType'] = ""
  finddict = {}
  for item in formdata
    if not item is ""
      finddict[item] = formdata[item]
  console.log(finddict)

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
