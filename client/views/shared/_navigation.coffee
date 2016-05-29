### On navigation template created ###

Template.navigation.onCreated ->
    @autorun =>
        # Set subscriptions
        @subscribe 'messages.all'

Template.navigation.helpers
    activeIfRouteNameIs: (routeName) ->
        if FlowRouter.getRouteName() == routeName
            return 'active'
        ''
    getUnreadCount: ->
        unreadMessageCount = 0
        messages = Messages.find($or: [
            {
                originatingFromId: Meteor.userId()
                'conversation.originatingFromDeleted': false
            }
            {
                originatingToId: Meteor.userId()
                'conversation.originatingToDeleted': false
            }
        ]).forEach((msg) ->
            x = 0
            while x < msg.conversation.length
                if msg.conversation[x].to.userId == Meteor.userId() and !msg.conversation[x].to.read
                    unreadMessageCount++
                x++
            return
        )
        if unreadMessageCount > 0
            '(' + unreadMessageCount + ')'
        else
            ''
