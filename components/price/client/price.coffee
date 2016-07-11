Template.view_price.helpers
    price: -> Template.parentData(0).price
    
    # like_item_class: -> if Template.parentData(0).likers and Meteor.userId() in Template.parentData(0).likers then 'red' else 'outline'
    
Template.edit_price.events
    'keydown .edit_price': (e,t)->
        if e.which is 13
            doc_id = Template.parentData(0)._id
            price = t.$('.edit_price').val()
            
            Meteor.call 'update_price', doc_id, price
