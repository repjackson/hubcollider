Template.followButton.events
    'click [data-id=follow]': (event, template) ->
        Meteor.call 'users.follow', @user._id, (error, result) ->
            if error
                # Bert.alert error.reason, 'danger', 'growl-top-right'
            else
                # Bert.alert "You are now following @#{@user.username}", 'success', 'growl-top-right'

    'click [data-id=unfollow]': (event, template) ->
        Meteor.call 'users.unfollow', @user._id, (error, result) ->
            if error
                # Bert.alert error.reason, 'danger', 'growl-top-right'
            else
                # Bert.alert "You have unfollowed @#{@user.username}", 'success', 'growl-top-right'


Template.followButton.helpers
    isThisUserNotCurrentUser: ->
        # console.log @user._id
        @user._id != Meteor.userId()

    isCurrentUserFollowingThisUser: ->
        Meteor.user().followingIds and @user._id in Meteor.user().followingIds
