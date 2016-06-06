Meteor.publish null, ->
    if @userId
        return Meteor.users.find({ _id: @userId }, fields:
            biography: 1
            followingIds: 1
            apps: 1
            tags: 1)
    return

Meteor.publish 'userStatus', ->
    Meteor.users.find 'status.online': true

Meteor.publishComposite 'posts.all', (query, filter, limit) ->
    if @userId
        currentUser = Meteor.users.findOne(_id: @userId)
        parameters =
            find: {}
            options: {}
        if filter == 'following'
            if currentUser.followingIds and currentUser.followingIds.length != 0
                parameters.find.authorId = $in: currentUser.followingIds
            else
                parameters.find.authorId = $in: []
        {
            find: ->
                if query
                    parameters.find.$text = $search: query
                    parameters.options =
                        fields: score: $meta: 'textScore'
                        sort: score: $meta: 'textScore'
                        limit: limit
                else
                    parameters.options =
                        sort: createdAt: -1
                        limit: limit
                Counts.publish this, 'posts.all', Posts.find(parameters.find), noReady: true
                Posts.find parameters.find, parameters.options
            children: [ { find: (post) ->
                Meteor.users.find { _id: post.authorId }, fields:
                    emails: 1
                    username: 1
             } ]
        }
    else
        []


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


Meteor.publish 'users.all', (query, limit) ->
    if @userId
        if query
            Counts.publish this, 'users.all', Meteor.users.find($text: $search: query), noReady: true
            Meteor.users.find { $text: $search: query },
                fields:
                    score: $meta: 'textScore'
                    tags: 1
                sort: score: $meta: 'textScore'
                limit: limit
        else
            Counts.publish this, 'users.all', Meteor.users.find(), noReady: true
            Meteor.users.find {},
                sort: createdAt: -1
                limit: limit
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

Meteor.publish 'selftags', ->
    Docs.find()
        # $all: tags: ['selftag']
        # authorId: @userId

Meteor.publish 'filtered_people', (selectedUserTags)->
    self = @
    # console.log selectedTags
    match = {}
    # match.apps = $in: ['hub_collider']
    if selectedUserTags and selectedUserTags.length > 0 then match.tags = $all: selectedUserTags

    Meteor.users.find match,
        fields:
            tags: 1
            username: 1

Meteor.publish 'people_tags', (selectedtags)->
    self = @
    match = {}
    if selectedtags?.length > 0 then match.tags = $all: selectedtags
    # match.apps = $in: ['hub_collider']
    match._id = $ne: @userId

    tagCloud = Meteor.users.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: "$tags" }
        { $group: _id: "$tags", count: $sum: 1 }
        { $match: _id: $nin: selectedtags }
        { $sort: count: -1, _id: 1 }
        { $limit: 50 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]

    tagCloud.forEach (tag, i) ->
        self.added 'people_tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    # console.log tagCloud

    self.ready()
