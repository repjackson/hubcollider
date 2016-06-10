@selected_tags = new ReactiveArray []
@selected_authors = new ReactiveArray []
Session.setDefault('view_more', false)

Template.cloud.onCreated ->
    @autorun -> Meteor.subscribe('tags', selected_tags.array(), selected_authors.array(), Session.get('view_more'))
    @autorun -> Meteor.subscribe('authors', selected_tags.array(), selected_authors.array())


Template.cloud.helpers
    all_tags: ->
        # docCount = Docs.find().count()
        # if 0 < docCount < 3 then Tags.find { count: $lt: docCount } else Tags.find()
        Tags.find()

    all_authors: -> Authors.find()

    selected_authors: -> selected_authors.list()

    username_view: -> Meteor.users.findOne(@text)?.username

    selected_username_view: -> Meteor.users.findOne(@valueOf())?.username

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

    can_view_less: -> Session.equals('view_more', true)

    can_view_more: ->
        Tags.find().count() > 10 and Session.equals('view_more', false)


Template.cloud.events
    'click #view_more': -> Session.set 'view_more', true
    'click #view_less': -> Session.set 'view_more', false

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


    'click .select_author': -> selected_authors.push @text
    'click .unselect_author': -> selected_authors.remove @valueOf()
    'click #clear_authors': -> selected_authors.clear()
