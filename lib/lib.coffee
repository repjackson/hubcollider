Meteor.methods
    update_username: (username)->
        existing_user = Meteor.users.findOne username:username
        if existing_user then throw new Meteor.Error 500, 'Username exists'
        else
            Meteor.users.update Meteor.userId(),
                $set: username: username
                
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
                
                
@Features = [
    # 'Voting'
    # 'Like'
    'Map'
    'Date'
    'Description'
    'Price'
    'Attendee'
    # 'Tag preselection'
    ]
    
    
