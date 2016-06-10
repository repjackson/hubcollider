@Docs = new (Mongo.Collection)('docs')

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.authorId = Meteor.userId()
    doc.down_voters = []
    doc.up_voters = []
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
        if tag then tags.push 'hubcollider', tag
        else tags.push 'hubcollider'
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
