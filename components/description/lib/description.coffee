Meteor.methods
    update_description: (doc_id, text) ->
        Docs.update doc_id,
            $set: description: text
