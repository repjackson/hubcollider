Template.messageButton.events
    'click [data-id=follow]': (event, template) ->
        FlowRouter.go


Template.messageButton.helpers
    # isThisUserNotCurrentUser: ->
    #     # console.log @user._id
    #     @user._id != Meteor.userId()

    # isCurrentUserFollowingThisUser: ->
    #     Meteor.user().followingIds and @user._id in Meteor.user().followingIds
