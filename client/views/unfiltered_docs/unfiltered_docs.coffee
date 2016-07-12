Template.unfiltered_docs.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'unfiltered_docs', selected_tags.array()
    

Template.unfiltered_docs.helpers
    docs: -> Docs.find()



Template.unfiltered_docs.events
    'click #add_doc': ->
        Meteor.call 'add_doc', (err, id)->
            if err then console.error err
            else FlowRouter.go "/docs/edit/#{id}"