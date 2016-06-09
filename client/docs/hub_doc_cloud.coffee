@selected_tags = new ReactiveArray []
@selectedUsernames = new ReactiveArray []
Session.setDefault('view_more': false)

Template.cloud.onCreated ->
    @autorun -> Meteor.subscribe 'tags', selected_tags.array(), Session.get('selected_user'), Session.get('view_more')
    # @autorun -> Meteor.subscribe('usernames', selected_tags.array(), selectedUsernames.array(), Session.get('view'))


Template.cloud.helpers
    globalTags: ->
        docCount = Docs.find().count()
        if 0 < docCount < 3 then Tags.find { count: $lt: docCount } else Tags.find()
        # Tags.find()


    globalTagClass: ->
        tag_class = ''
        switch
            when @index <= 10 then tag_class += ' big'
            when @index <= 20 then tag_class += ' large'
            when @index <= 30 then tag_class += ' '
            when @index <= 40 then tag_class += ' small'
            when @index <= 50 then tag_class += ' tiny'

        if @name is 'academy' then tag_class += ' yellow'
        if @name is 'economy' then tag_class += ' green'

        return tag_class

    selected_tags: -> selected_tags.list()

    user: -> Meteor.user()
    selected_user: -> if Session.get 'selected_user' then Meteor.users.findOne(Session.get('selected_user'))?.username

    selected_tag_class: ->
        tag_class = switch
            when @valueOf() is 'academy' then 'yellow'
            when @valueOf() is 'economy' then 'green'
            else 'primary'
        return tag_class

Template.cloud.events
    'click #view_more': ->
        Session.set 'view_more': true

    'click .selectTag': ->
        selected_tags.push @name
        FlowRouter.setQueryParams( filter: selected_tags.array() )
        # console.log FlowRouter.getQueryParam('filter');

    'click .unselectTag': ->
        selected_tags.remove @valueOf()
        FlowRouter.setQueryParams( filter: selected_tags.array() )
        # console.log FlowRouter.getQueryParam('filter');

    'click #clearTags': ->
        selected_tags.clear()
        FlowRouter.setQueryParams( filter: null )
        # console.log FlowRouter.getQueryParam('filter');

    'click #bookmarkSelection': ->
        # if confirm 'Bookmark Selection?'
        Meteor.call 'add_bookmark', selected_tags.array(), (err,res)->
            alert "Selection bookmarked"

    'click .selected_user_button': -> Session.set 'selected_user', null
