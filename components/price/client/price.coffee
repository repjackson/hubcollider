Template.price.onCreated ->
    @editing_price = new ReactiveVar false

Template.price.helpers
    price: -> Template.parentData(0).price
    

Template.price.events
    'click .save_price': (e,t)->
        doc_id = Template.parentData(0)._id
        price = t.$('.edit_price').val()
        Meteor.call 'update_price', doc_id, price