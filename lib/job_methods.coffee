Meteor.methods
    add_job: ()->
        Docs.insert
            type: 'job'
            tags: ['job']

    delete_job: (id)->
        Docs.remove id

    remove_job_tag: (tag, doc_id)->
        Docs.update doc_id,
            $pull: tag

    add_job_tag: (tag, doc_id)->
        Docs.update doc_id,
            $addToSet: tags: tag
