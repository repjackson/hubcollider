Template.nav.onCreated ->
    @autorun =>
        # Set subscriptions
        @subscribe 'messages.all'
        # @subscribe 'users.all'


Template.nav.events
    'click [data-id=sign-out]': ->
        Meteor.logout (error) ->
            if error
                alert error.reason
            else
                FlowRouter.go '/sign-in'

    'click #add_doc': ->
        Meteor.call 'create_doc', null ,(err, id)->
            if err then console.log err
            else FlowRouter.go "/edit/#{id}"

    'click #add_econ': ->
        Meteor.call 'create_doc', 'economy', (err, id)->
            if err then console.log err
            else FlowRouter.go "/edit/#{id}"

    'click #add_acad': ->
        Meteor.call 'create_doc', 'academy', (err, id)->
            if err then console.log err
            else FlowRouter.go "/edit/#{id}"

    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_tags.pop()

    'click #academy_link': ->
        FlowRouter.go '/'
        selected_tags.clear()
        selected_tags.push 'academy'

    'click #perks_link': ->
        selected_tags.clear()
        selected_tags.push 'perks'
        FlowRouter.go '/'

    'click #economy_link': ->
        selected_tags.clear()
        FlowRouter.go '/'
        selected_tags.push 'economy'

    'click #crowd_sourcing_link': ->
        selected_tags.clear()
        FlowRouter.go '/'
        selected_tags.push 'crowd sourcing'

Template.nav.helpers
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

Template.body.events
    # 'click .inverted': (e,t) ->
    #     e.preventDefault()
    #     document.documentElement.style.Filter = 'invert(0%)'
    #     console.log 'this was clicked'
    #     console.log document.documentElement.style.Filter
    #     return
