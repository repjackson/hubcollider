# Template.nav.onCreated ->
#     @autorun =>
        # Set subscriptions
        # @subscribe 'messages.all'
        # @subscribe 'users.all'

# Template.nav.helpers
    # is_editing: -> Session.equals('is_editing', @_id)

Template.nav.events
    'click [data-id=sign-out]': ->
        Meteor.logout (error) ->
            if error
                alert error.reason
            else
                FlowRouter.go '/sign-in'

    'click #view_me': -> if Meteor.userId() in selected_authors.array() then selected_authors.remove Meteor.userId() else selected_authors.push Meteor.userId()


    # 'click .select_bookmark': ->
    #     selected_tags.clear()
    #     selected_tags.push(tag) for tag in @

    # 'click .add_from_bookmark': ->
    #     Meteor.call 'create_doc', @, (err,id)->
    #         if err then console.log err
    #         else Session.set('is_editing', id)

    'click .search.link.icon': ->
        val = $('#search').val()
        if val.length > 0 then selected_tags.push val.toString()


    'click #create_doc': ->
        Meteor.call 'create_doc', null ,(err, id)->
            if err then console.log err
            else FlowRouter.go "/edit/#{id}"
    
    'click #profile_link': -> FlowRouter.go "/users/#{Meteor.userId()}"

    'keyup .search': (e,t)->
        e.preventDefault()
        val = e.currentTarget.value
        # console.log val
        # val = $('#search').val()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_tags.clear()
                        e.currentTarget.value = ''
                    else
                        unless val.length is 0 or val in selected_tags.array()
                            selected_tags.push val.toString()
                            e.currentTarget.value = ''
            when 8
                if val.length is 0
                    selected_tags.pop()

    'click #home_link': ->
        selected_tags.clear()
        selected_authors.clear()
        FlowRouter.go '/'



Template.nav.helpers
    activeIfRouteNameIs: (routeName) ->
        if FlowRouter.getRouteName() == routeName
            return 'active'
        ''

    selected_tags: -> selected_tags.list()

    view_me_class: -> if Meteor.user().username in selected_authors.array() then 'active' else ''


Template.body.events
    # 'click .inverted': (e,t) ->
    #     e.preventDefault()
    #     document.documentElement.style.Filter = 'invert(0%)'
    #     console.log 'this was clicked'
    #     console.log document.documentElement.style.Filter
    #     return
