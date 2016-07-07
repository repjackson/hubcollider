Meteor.publish null, ->
    if @userId
        return Meteor.users.find({ _id: @userId }, fields:
            apps: 1
            bookmarks: 1
            tags: 1
            authored_cloud: 1
            authored_list: 1)
    return

Meteor.publish 'userStatus', ->
    Meteor.users.find 'status.online': true


Meteor.publish 'users.all', () ->
    if @userId
        Counts.publish this, 'users.all', Meteor.users.find(), noReady: true
        Meteor.users.find {},
            fields:
                username: 1
                bookmarks: 1
                tags: 1
                authored_cloud: 1
                authored_list: 1
    else
        []


Meteor.publish 'person', (id)->
    Meteor.users.find id,
        fields:
            tags: 1
            username: 1
            authored_cloud: 1
            authored_list: 1


Meteor.publish 'doc', (id)-> Docs.find id



Meteor.publish 'job_tags', (selected_job_tags)->
    self = @

    match = {}
    limit = 25
    if selected_job_tags.length then match.tags = $all: selected_job_tags

    cloud = Jobs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_job_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: limit }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]

    cloud.forEach (tag, i) ->
        self.added 'job_tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()



Meteor.publish 'docs', (selected_tags, selected_authors)->
    match = {}
    if selected_tags.length then match.tags = $all: selected_tags
    if selected_authors.length > 0 then match.authorId = $in: selected_authors

    Docs.find match,
        sort:
            tagCount: 1
            timestamp: -1
        limit: 10

Meteor.publish 'authors', (selected_tags, selected_authors)->
    self = @

    match = {}
    if selected_tags.length then match.tags = $all: selected_tags
    if selected_authors.length > 0 then match.authorId = $in: selected_authors

    cloud = Docs.aggregate [
        { $match: match }
        { $project: authorId: 1 }
        { $group: _id: '$authorId', count: $sum: 1 }
        { $match: _id: $nin: selected_authors }
        { $sort: count: -1, _id: 1 }
        { $limit: 10 }
        { $project: _id: 0, text: '$_id', count: 1 }
        ]

    cloud.forEach (author) ->
        self.added 'authors', Random.id(),
            text: author.text
            count: author.count
    self.ready()






Meteor.publish 'job', (id)-> Jobs.find id
Meteor.publish 'jobs', -> Jobs.find()