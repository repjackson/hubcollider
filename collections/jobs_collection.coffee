@Jobs = new Mongo.Collection 'jobs'
@Job_tags = new Mongo.Collection 'job_tags'

Jobs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.authorId = Meteor.userId()
    return

Jobs.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tagCount = doc.tags?.length
    # Meteor.call 'generatePersonalCloud', Meteor.userId()
), fetchPrevious: true

Jobs.helpers
    author: -> Meteor.users.findOne @authorId


Meteor.methods
    add_job: ()->
        Jobs.insert({})

    delete_job: (id)->
        Jobs.remove id

    remove_job_tag: (tag, docId)->
        Jobs.update docId,
            $pull: tag

    add_job_tag: (tag, docId)->
        Jobs.update docId,
            $addToSet: tags: tag
