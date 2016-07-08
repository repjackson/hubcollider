@selected_tags = new ReactiveArray []


Template.docs.onCreated ->
    @autorun -> Meteor.subscribe 'docs', selected_tags.array()

Template.docs.events
    'click #add_post': ->
        text = $('#post_area').val()
        console.log text
        Docs.insert
            tags: ['post']
            text: text

Template.docs.helpers
    docs: -> Docs.find {},
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
    