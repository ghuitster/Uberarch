Artifacts = Meteor.Collection("artifacts")

Template.artifact_search.artifacts = ->
  # Session.set('searched_artifacts', Artifacts.find({}))
  # return Session.get('searched_artifacts')
  Artifacts.find({})

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
