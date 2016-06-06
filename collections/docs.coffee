@Docs = new (Mongo.Collection)('docs')

Docs.before.insert (userId, doc)->
    doc.createdAt = Date.now()
    doc.authorId = Meteor.userId()
    return


Meteor.methods
    'docs.insert': (tags) ->
        Docs.insert
            tags: tags

    'docs.remove': (_id) ->
        Docs.remove _id: _id

