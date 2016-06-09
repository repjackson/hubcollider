@Docs = new (Mongo.Collection)('docs')

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.authorId = Meteor.userId()
    return

Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tagCount = doc.tags.length
    # Meteor.call 'generatePersonalCloud', Meteor.userId()
), fetchPrevious: true

Docs.helpers
    author: -> Meteor.users.findOne @authorId


Meteor.methods
    create_doc: (tag)->
        tags = []
        tags.push 'hubcollider', tag
        Docs.insert
            tags: tags

    delete_doc: (id)->
        Docs.remove id

    remove_tag: (tag, docId)->
        Docs.update docId,
            $pull: tag

    add_tag: (tag, docId)->
        Docs.update docId,
            $addToSet: tags: tag
