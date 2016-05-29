Template.follower.helpers users: ->
    Meteor.users.find { _id: $ne: Meteor.userId() }, sort: username: 1


Template.follower.onCreated ->
    @autorun ->
        @subscribe 'users.follower'