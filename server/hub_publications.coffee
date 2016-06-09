Meteor.publish null, ->
    if @userId
        return Meteor.users.find({ _id: @userId }, fields:
            apps: 1
            bookmarks: 1
            tags: 1)
    return

Meteor.publish 'userStatus', ->
    Meteor.users.find 'status.online': true


Meteor.publishComposite 'users.profile', (_id, limit) ->
    if @userId
        {
            find: ->
                Meteor.users.find _id: _id
            children: [ { find: (user) ->
                Counts.publish this, 'users.profile', Posts.find(authorId: user._id), noReady: true
                Posts.find { authorId: user._id },
                    sort: createdAt: -1
                    limit: limit
             } ]
        }
    else
        []


Meteor.publish 'users.all', () ->
    if @userId
        Counts.publish this, 'users.all', Meteor.users.find(), noReady: true
        Meteor.users.find {},
            sort: createdAt: -1
    else
        []


Meteor.publish 'messages.all', ->
    if @userId
        currentUser = Meteor.users.findOne(_id: @userId)
        Messages.find $or: [
            { originatingFromId: currentUser._id }
            { originatingToId: currentUser._id }
        ]
    else
        []

Meteor.publish 'person', (id)->
    Meteor.users.find id,
        fields:
            tags: 1
            username: 1


# Meteor.publish 'filtered_people', (selectedUserTags)->
#     self = @
#     # console.log selected_tags
#     match = {}
#     # match.apps = $in: ['hub_collider']
#     if selectedUserTags and selectedUserTags.length > 0 then match.tags = $all: selectedUserTags

#     Meteor.users.find match,
#         fields:
#             tags: 1
#             username: 1

# Meteor.publish 'people_tags', (selected_tags)->
#     self = @
#     match = {}
#     if selected_tags?.length > 0 then match.tags = $all: selected_tags
#     # match.apps = $in: ['hub_collider']
#     match._id = $ne: @userId

#     tagCloud = Meteor.users.aggregate [
#         { $match: match }
#         { $project: tags: 1 }
#         { $unwind: "$tags" }
#         { $group: _id: "$tags", count: $sum: 1 }
#         { $match: _id: $nin: selected_tags }
#         { $sort: count: -1, _id: 1 }
#         { $limit: 50 }
#         { $project: _id: 0, name: '$_id', count: 1 }
#         ]

#     tagCloud.forEach (tag, i) ->
#         self.added 'people_tags', Random.id(),
#             name: tag.name
#             count: tag.count
#             index: i

#     # console.log tagCloud

#     self.ready()


Meteor.publish 'doc', (id)-> Docs.find id


Meteor.publish 'tags', (selected_tags, selected_authors, view_more)->
    self = @

    match = {}
    if view_more is true then limit = 50 else limit = 10
    selected_tags.push 'hubcollider'
    match.tags = $all: selected_tags

    if selected_authors.length > 0 then match.authorId = $in: selected_authors

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



Meteor.publish 'docs', (selected_tags, selected_authors)->
    match = {}
    selected_tags.push 'hubcollider'
    match.tags = $all: selected_tags
    if selected_authors.length > 0 then match.authorId = $in: selected_authors

    Docs.find match,
        # limit: 5
        sort:
            tagCount: 1
            timestamp: -1


Meteor.publish 'authors', (selected_tags, selected_authors)->
    self = @

    match = {}
    selected_tags.push 'hubcollider'
    match.tags = $all: selected_tags
    if selected_authors.length > 0 then match.authorId = $in: selected_authors

    cloud = Docs.aggregate [
        { $match: match }
        { $project: authorId: 1 }
        { $group: _id: '$authorId', count: $sum: 1 }
        { $match: _id: $nin: selected_authors }
        { $sort: count: -1, _id: 1 }
        { $limit: 50 }
        { $project: _id: 0, text: '$_id', count: 1 }
        ]

    cloud.forEach (author) ->
        self.added 'authors', Random.id(),
            text: author.text
            count: author.count
    self.ready()
