# Set up a database that can be accessed from the client,
# or from the server and put it in the global namespace #
exports = this
Artifacts = new Meteor.Collection "artifacts", {idGeneration: 'MONGO'}
DBEntryCount = null
exports.Artifacts = Artifacts
exports.DBEntryCount = DBEntryCount

# Global convenience functions #
getDataFromForm = (formID)->
  retobj = {}
  $("#{formID} > *").each ->
    field = $(@)
    if !!field.val() and field.val() isnt "Filter by Type"
      retobj[field.attr('id')] = field.val()
  return retobj
#
