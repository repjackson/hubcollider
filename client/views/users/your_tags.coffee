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
    'keydown #add_self_tag': (e,t)->
        e.preventDefault
        tag = $('#add_self_tag').val().toLowerCase().trim()
        switch e.which
            when 13
                if tag.length > 0
                    Meteor.call 'add_self_tag', tag, ->
                        $('#add_self_tag').val('')

    'click .remove_self_tag': ->
        tag = @valueOf()
        Meteor.call 'remove_self_tag', tag, ->
            $('#add_self_tag').val(tag)
