Meteor.methods
    update_price: (doc_id, price) ->
        Docs.update doc_id,
            $set: price: price
