Meteor.publish 'comments.doc', (doc_id)->
    Comments.find
        doc_id: doc_id