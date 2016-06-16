Template.top_matches.onCreated ->
    Meteor.subscribe 'users.all'


Template.top_matches.helpers
    user: -> Meteor.user()

    people: -> Meteor.users.find()

    matchedUsersList:->
        users = Meteor.users.find({ _id: $ne: Meteor.userId() }).fetch()
        userMatches = []
        for user in users
            tagIntersection = _.intersection(user.authored_list, Meteor.user().authored_list)
            userMatches.push
                matched_user_id: user._id
                matchedUser: user.username
                tagIntersection: tagIntersection
                length: tagIntersection.length
        sortedList = _.sortBy(userMatches, 'length').reverse()
        clipped_list = []
        for item in sortedList
            # console.log item
            clipped_list.push
                matchedUser: item.matchedUser
                tagIntersection: item.tagIntersection.slice(0,5)
                length: item.length

        # console.log(item) for item in clipped_list
        return clipped_list
        # return sortedList


Template.top_matches.events
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
