Template.docs.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'docs', selected_tags.array()
    

Template.docs.helpers
    docs: -> Docs.find()



Template.docs.events
    'click #add_doc': ->
        Meteor.call 'add_doc', (err, id)->
            if err then console.error err
            else FlowRouter.go "/edit/#{id}"


Template.view_doc.helpers
    is_author: -> Meteor.userId() and Meteor.userId() is @author_id 
    template_name: -> "#{@toLowerCase()}"
    doc_tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'

Template.view_doc.events
    'click .edit_doc': -> FlowRouter.go "/edit/#{@_id}"
    'click .doc_tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()