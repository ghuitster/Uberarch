Template.add_artifact.events "click button#random": ->
  $("#Northing").val(getRandomInt(0, 9))
  $("#Easting").val(getRandomInt(0, 9))
  $("#Datum").val(0)
  $("#Notes").val(getRandomWord(5) + " " + getRandomWord(10))
  $("#Username").val(getRandomWord(7))
  $("#ArtifactNumber").val(getRandomInt(24587, 52804))
  $("#ArtifactType").get(0).selectedIndex = getRandomInt(1, 4)
  $("#Depth").val(getRandomInt(0, 8) + "." + getRandomInt(0, 9))