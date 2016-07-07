Meteor.methods
    add_event: ()->
        Docs.insert
            type: 'event'
            tags: ['event']

    delete_event: (id)->
        Docs.remove id

    remove_event_tag: (tag, doc_id)->
        Docs.update doc_id,
            $pull: tag

    add_event_tag: (tag, doc_id)->
        Docs.update doc_id,
            $addToSet: tags: tag
