@Comments = new (Mongo.Collection)('comments')

Meteor.methods
    'comments.insert': (doc_id, text) ->
        Comments.insert
            doc_id: doc_id
            text: text
            timestamp: Date.now()
            authorId: Meteor.userId()

        Docs.update doc_id,
            $inc: comment_count: 1