@Docs = new (Mongo.Collection)('docs')

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return

Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags?.length
    # Meteor.call 'generatePersonalCloud', Meteor.userId()
), fetchPrevious: true

Docs.helpers
    author: -> Meteor.users.findOne @author_id


Meteor.methods
    create_doc: ()->
        Docs.insert({})

    delete_doc: (id)->
        Docs.remove id

    remove_tag: (tag, docId)->
        Docs.update docId,
            $pull: tag

    add_tag: (tag, docId)->
        Docs.update docId,
            $addToSet: tags: tag
