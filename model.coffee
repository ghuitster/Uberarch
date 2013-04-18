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

getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

getRandomWord = (length) ->
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

fillDb = (numentries) ->
  for i in [0..numentries - 1]
    DBNumber = Artifacts.find({}).count() + 1
    insertobj = {
      Notes: "#{getRandomWord(5)} #{getRandomWord(10)}"
      Northing: "#{getRandomInt(0,9)}"
      Easting: "#{getRandomInt(0,9)}"
      Datum: "0"
      Username: "#{getRandomWord(6)}"
      ArtifactNumber: "#{getRandomInt(0,20000)}"
      ArtifactType: "#{getRandomInt(1,4)}"
      DBNumber: "#{DBNumber}"
      Depth: "#{getRandomInt(0, 8)}.#{getRandomInt(0, 9)}"
    }
    Artifacts.insert insertobj

exports.getRandomInt = getRandomInt
exports.getRandomWord = getRandomWord
exports.getDataFromForm = getDataFromForm 

# fillDb(80)