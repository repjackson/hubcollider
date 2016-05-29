Template.followButton.events
    'click [data-id=follow]': (event, template) ->
        Meteor.call 'users.follow', @user._id, (error, result) ->
            if error
                Bert.alert error.reason, 'danger', 'growl-top-right'
            else
                Bert.alert "You are now following @#{this.user.username}", 'success', 'growl-top-right'
            return
        return

    'click [data-id=unfollow]': (event, template) ->
        Meteor.call 'users.unfollow', @user._id, (error, result) ->
            if error
                Bert.alert error.reason, 'danger', 'growl-top-right'
            else
                Bert.alert "You have unfollowed @#{this.user.username}", 'success', 'growl-top-right'
            return
        return
Template.followButton.helpers
    isThisUserNotCurrentUser: ->
        @user._id != Meteor.userId()

    isCurrentUserFollowingThisUser: ->
        Meteor.user().followingIds and Meteor.user().followingIds.indexOf(@user._id) > -1
