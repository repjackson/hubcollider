Template.following.helpers users: ->
    if Meteor.user().followingIds and Meteor.user().followingIds.length != 0
        Meteor.users.find { _id: $in: Meteor.user().followingIds }, sort: username: 1
    else
        []


Template.following.onCreated ->
    @autorun ->
        @subscribe 'users.following'
