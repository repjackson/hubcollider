Meteor.publish 'people_tags', (selectedtags)->
    check(selectedtags, Array)

    self = @
    match = {}
    if selectedtags?.length > 0 then match.tags = $all: selectedtags
    # match._id = $ne: @userId

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

    console.log tagCloud

    self.ready()
