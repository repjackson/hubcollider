Template.price.onCreated ->
    @editing_price = new ReactiveVar false

Template.price.helpers
    editing_price: -> Template.instance().editing_price.get()

    price: -> Template.parentData(0).price
    

Template.price.events
    'click .edit_price': (e,t)->
        t.editing_price.set true

    'click .save_price': (e,t)->
        doc_id = Template.parentData(0)._id
        price = t.$('.edit_price').val()
        Meteor.call 'update_price', doc_id, price
        t.editing_price.set false