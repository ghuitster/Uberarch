Template.view_teams.makeflickable = ->
	Meteor.defer ->
		Flickable '.flickable', enableMouseEvents: true
