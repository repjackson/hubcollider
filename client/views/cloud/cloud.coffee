@selected_tags = new ReactiveArray []
@selected_authors = new ReactiveArray []
Session.setDefault('view_more', false)

# filter = Template.currentData().filter

Template.cloud.onCreated ->
    console.log Template.currentData().filter
    @autorun -> Meteor.subscribe 'tags', selected_tags.array(), Template.currentData().filter
    # @autorun -> Meteor.subscribe 'tags', selected_tags.array()
    # @autorun -> Meteor.subscribe('authors', selected_tags.array())


Template.cloud.helpers
    all_tags: ->
        # docCount = Docs.find().count()
        # if 0 < docCount < 3 then Tags.find { count: $lt: docCount } else Tags.find()
        Tags.find()

    # all_authors: -> Authors.find()

    # selected_authors: -> selected_authors.list()

    # username_view: -> Meteor.users.findOne(@text)?.username

    # selected_username_view: -> Meteor.users.findOne(@valueOf())?.username

    # cloud_tag_class: ->
    #     buttonClass = switch
    #         when @index <= 5 then 'large'
    #         when @index <= 10 then ''
    #         when @index <= 15 then 'small'
    #         when @index <= 20 then 'tiny'
    #     return buttonClass

    selected_tags: -> selected_tags.list()

    # selected_user: -> if Session.get 'selected_user' then Meteor.users.findOne(Session.get('selected_user'))?.username

    # selected_tag_class: ->
    #     tag_class = switch
    #         # when @valueOf() is 'academy' then 'yellow'
    #         # when @valueOf() is 'economy' then 'green'
    #         else 'primary'
    #     return tag_class

    # can_view_less: -> Session.equals('view_more', true)

    # can_view_more: -> Session.equals('view_more', false)


Template.cloud.events
    'click #view_more': -> Session.set 'view_more', true
    'click #view_less': -> Session.set 'view_more', false

    'click .select_tag': ->
        selected_tags.push @name
        FlowRouter.setQueryParams( filter: selected_tags.array() )
        # console.log FlowRouter.getQueryParam('filter');

    'click .unselect_tag': ->
        selected_tags.remove @valueOf()
        FlowRouter.setQueryParams( filter: selected_tags.array() )
        # console.log FlowRouter.getQueryParam('filter');

    'click #clear_tags': ->
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
