@selected_post_tags = new ReactiveArray []


Template.feed.onCreated ->
    @autorun -> Meteor.subscribe 'docs', selected_post_tags.array(), 'post'
    Session.setDefault('is_editing', null)


Template.feed.helpers
    posts: -> Docs.find {},
        # limit: 5
        sort:
            points: -1
            timestamp: -1
    # docs: -> Docs.find()
    
    
Template.post_cloud.helpers
    selected_post_tags: -> selected_post_tags.array()
    
Template.feed.events
    'click #add_post': ->
        text = $('#post_area').val()
        console.log text
        Docs.insert
            tags: ['post']
            text: text

Template.feed.helpers
    is_editing: -> Session.equals('is_editing', @_id)