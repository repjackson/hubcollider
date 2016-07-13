Template.description.onCreated ->
    @editing_description = new ReactiveVar false

Template.description.helpers
    editing_description: -> Template.instance().editing_description.get()
    description: -> Template.parentData(0).description

Template.description.events
    'click .edit_description': (e,t)->
        t.editing_description.set true


    'click .save_description': (e,t)->
        doc_id = Template.parentData(0)._id
        text = t.$('.text').val()
        # console.log Template.parentData(1)
        
        Meteor.call 'update_description', doc_id, text
        t.editing_description.set false