Template.your_tags.helpers
    user: -> Meteor.user()

    people: -> Meteor.users.find()

    matchedUsersList:->
        users = Meteor.users.find({_id: $ne: Meteor.userId()}).fetch()
        userMatches = []
        for user in users
            tagIntersection = _.intersection(user.tags, Meteor.user().tags)
            userMatches.push
                matchedUser: user.username
                tagIntersection: tagIntersection
                length: tagIntersection.length
        sortedList = _.sortBy(userMatches, 'length').reverse()
        return sortedList


Template.your_tags.events
    'keydown #addtag': (e,t)->
        e.preventDefault
        tag = $('#addtag').val().toLowerCase().trim()
        switch e.which
            when 13
                if tag.length > 0
                    Meteor.call 'addtag', tag, ->
                        $('#addtag').val('')

    'click .tag': ->
        tag = @valueOf()
        Meteor.call 'removetag', tag, ->
            $('#addtag').val(tag)
