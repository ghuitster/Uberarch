if Meteor.isClient
  Template.add_artifact.events "click button#random": ->
    # Helpful functions
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
    #
    $("#Northing").val(getRandomInt(0, 9))
    $("#Easting").val(getRandomInt(0, 9))
    $("#Datum").val(0)
    $("#Notes").val(createRandomWord(5) + " " + createRandomWord(10))
    $("#Username").val(createRandomWord(7))
    $("#ArtifactNumber").val(getRandomInt(24587, 52804))
    $("#ArtifactType").get(0).selectedIndex = getRandomInt(1, 4)
    $("#Depth").val(getRandomInt(0, 8) + "." + getRandomInt(0, 9))