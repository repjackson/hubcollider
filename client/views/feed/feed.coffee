@selected_post_tags = new ReactiveArray []


Template.feed.onCreated ->
    @autorun -> Meteor.subscribe 'docs', selected_post_tags.array(), 'post'
    Session.setDefault('is_editing', null)

    
Template.post_cloud.helpers
    selected_post_tags: -> selected_post_tags.array()
    
    all_post_tags: ->
        # docCount = Docs.find().count()
        # if 0 < docCount < 3 then Tags.find { count: $lt: docCount } else Tags.find()
        Tags.find()

    # cloud_tag_class: ->
    #     buttonClass = switch
    #         when @index <= 5 then 'large'
    #         when @index <= 10 then ''
    #         when @index <= 15 then 'small'
    #         when @index <= 20 then 'tiny'
    #     return buttonClass

Template.post_cloud.events
    'click .select_post_tag': -> selected_post_tags.push @name

    'click .unselect_post_tag': -> selected_post_tags.remove @valueOf()

    'click #clear_post_tags': -> selected_post_tags.clear()



Template.feed.events
    'click #add_post': ->
        text = $('#post_area').val()
        console.log text
        Docs.insert
            tags: ['post']
            text: text

Template.feed.helpers
    posts: -> Docs.find {},
        # limit: 5
        sort:
            points: -1
            timestamp: -1
    # docs: -> Docs.find()

    is_editing: -> Session.equals('is_editing', @_id)
    
Template.view_post.events
    'click .edit_post': -> Session.set 'is_editing', @_id
        
        
Template.view_post.helpers
    post_tags: -> _.without(@tags, 'post')
    
    is_author: -> Meteor.userId() is @authorId


Template.edit_post.events
    'click .save_post': (e,t)->
        id = Template.currentData()._id
        text = t.find('.post_text').value
        Docs.update id,
            $set: text: text
        Session.set 'is_editing', null
        
    'keydown #add_post_tag': (e,t)->
        switch e.which
            when 13
                post_id = Session.get 'is_editing'
                tag = $('#add_post_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Docs.update post_id,
                        $addToSet: tags: tag
                    $('#add_post_tag').val('')

    
Template.edit_post.helpers
    post_tags: -> _.without(@tags, 'post')
    