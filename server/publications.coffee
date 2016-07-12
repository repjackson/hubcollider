Meteor.publish null, ->
    if @userId
        return Meteor.users.find({ _id: @userId }, fields:
            apps: 1
            bookmarks: 1
            tags: 1
            authored_cloud: 1
            authored_list: 1)
    return

Meteor.publish 'people', () ->
    if @userId
        Meteor.users.find {},
            fields:
                username: 1
                tags: 1
    else
        []


Meteor.publish 'person', (id)->
    Meteor.users.find id,
        fields:
            tags: 1
            username: 1


Meteor.publish 'doc', (id)-> Docs.find id



Meteor.publish 'tags', (selected_tags, filter='', limit=10)->
    self = @
    match = {}
    # console.log filter
    selected_tags.push filter
    match.tags = $all: selected_tags

    cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: limit }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
        
    cloud.forEach (tag, i) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()


Meteor.publish 'unfiltered_tags', (selected_tags=[])->
    self = @
    match = {}
    match.tags = $all: selected_tags

    cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: limit }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
        
    cloud.forEach (tag, i) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()
    

Meteor.publish 'my_tags', (selected_tags)->
    self = @
    match = {}
    if selected_tags then match.tags = $all: selected_tags
    match.author_id = @userId

    cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 20 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
        
    cloud.forEach (tag, i) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()



Meteor.publish 'docs', (selected_tags, filter='')->
    match = {}
    selected_tags.push filter
    match.tags = $all: selected_tags

    Docs.find match,
        sort:
            tag_count: 1
            timestamp: -1
        limit: 10



Meteor.publish 'my_docs', ()->
    match = {}
    match.author_id= @userId
    Docs.find match,
        sort:
            tag_count: 1
            timestamp: -1
        limit: 100

Meteor.publish 'doc_comments', (doc_id)->
    Comments.find doc_id: doc_id


# Meteor.publish 'authors', (selected_tags, selected_authors)->
#     self = @

#     match = {}
#     if selected_tags.length then match.tags = $all: selected_tags
#     if selected_authors.length > 0 then match.author_id = $in: selected_authors

#     cloud = Docs.aggregate [
#         { $match: match }
#         { $project: author_id: 1 }
#         { $group: _id: '$author_id', count: $sum: 1 }
#         { $match: _id: $nin: selected_authors }
#         { $sort: count: -1, _id: 1 }
#         { $limit: 10 }
#         { $project: _id: 0, text: '$_id', count: 1 }
#         ]

#     cloud.forEach (author) ->
#         self.added 'authors', Random.id(),
#             text: author.text
#             count: author.count
#     self.ready()

