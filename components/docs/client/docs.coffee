Template.docs.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'docs', selected_tags.array(), Template.currentData().filter
    

Template.docs.helpers
    docs: -> Docs.find()



Template.docs.events
    'click #add_doc': ->
        Meteor.call 'add_doc', (err, id)->
            if err then console.error err
            else FlowRouter.go "/docs/edit/#{id}"


Template.view_doc.helpers
    is_author: -> Meteor.userId() and Meteor.userId() is @author_id 

Template.view_doc.events
    'click .edit_doc': -> FlowRouter.go "/docs/edit/#{@_id}"