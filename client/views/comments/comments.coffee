@selected_event_tags = new ReactiveArray []

Template.comments.onCreated ->
    doc_id = Template.parentData(0)._id
    self = @
    self.autorun ->
        self.subscribe 'doc_comments', doc_id
    

Template.comments.helpers
    comments: -> 
        doc_id = Template.parentData(0)._id
        Comments.find( doc_id: doc_id )



Template.comments.events
    'click .submit_comment': (e,t)->
        text = t.$('.new_comment').val()
        doc_id = Template.parentData(0)._id
        Meteor.call 'insert_comment', doc_id, text


Template.comment.helpers
    is_author: -> Meteor.userId() and Meteor.userId() is @authorId 
    comment: -> console.log doc

Template.comment.events
    'click .edit_event': -> FlowRouter.go "/comments/edit/#{@_id}"
    
    
    