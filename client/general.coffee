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
  return "" # --> This is so that nothing renders on the page that's not supposed to.
######

### These are global helpers for all of the pages. ###
Handlebars.registerHelper "iscurrentpage", (page) ->
  return page is Session.get "current_page"

Handlebars.registerHelper "getcurrentpage", (page) ->
  return Session.get "current_page"
######
