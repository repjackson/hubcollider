@Tags = new Meteor.Collection 'tags'
@Docs = new Meteor.Collection 'docs'


@Docs = new (Mongo.Collection)('docs')

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return

Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags.length
    # Meteor.call 'generatePersonalCloud', Meteor.userId()
), fetchPrevious: true

Docs.helpers
    author: -> Meteor.users.findOne @author_id


Meteor.methods
    create_doc: (tag)->
        tags = []
        if tag then tags.push tag
        Docs.insert
            tags: tags

    delete_doc: (id)->
        Docs.remove id

    remove_tag: (tag, doc_id)->
        Docs.update doc_id,
            $pull: tag

    add_tag: (tag, doc_id)->
        Docs.update doc_id,
            $addToSet: tags: tag
