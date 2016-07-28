@Tags = new Meteor.Collection 'tags'
@Docs = new Meteor.Collection 'docs'

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
    add_doc: (tags=[])->
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


FlowRouter.route '/',
    action: ->
        BlazeLayout.render 'layout', main: 'docs'


FlowRouter.route '/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit'
