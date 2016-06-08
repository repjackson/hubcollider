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
        buttonClass = switch
            when @index <= 10 then 'big'
            when @index <= 20 then 'large'
            when @index <= 30 then ''
            when @index <= 40 then 'small'
            when @index <= 50 then 'tiny'
        return buttonClass

    selected_tags: -> selected_tags.list()

    user: -> Meteor.user()
    selected_user: -> if Session.get 'selected_user' then Meteor.users.findOne(Session.get('selected_user'))?.username



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
        Meteor.call 'addBookmark', selected_tags.array(), (err,res)->
            alert "Selection bookmarked"

    'click .selected_user_button': -> Session.set 'selected_user', null
