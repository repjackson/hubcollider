Template.profile.helpers
    user_matches: ->
        users = Meteor.users.find({_id: $ne: Meteor.userId()}).fetch()
        user_matches = []
        for user in users
            tag_intersection = _.intersection(user.tags, Meteor.user().tags)
            user_matches.push
                matched_user: user.username
                tag_intersection: tag_intersection
                length: tag_intersection.length
        sortedList = _.sortBy(user_matches, 'length').reverse()
        return sortedList

    settings: ->
        {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    # token: ''
                    collection: Tags
                    field: 'name'
                    matchAll: true
                    template: Template.tag_result
                }
            ]
        }


Template.profile.events
    'keydown #add_tag': (e,t)->
        e.preventDefault
        tag = $('#add_tag').val().toLowerCase().trim()
        switch e.which
            when 13
                if tag.length > 0
                    Meteor.call 'add_tag', tag, ->
                        $('#add_tag').val('')

    'keydown #username': (e,t)->
        e.preventDefault
        username = $('#username').val().trim()
        switch e.which
            when 13
                if username.length > 0
                    Meteor.call 'update_username', username, (err,res)->
                        if err
                            alert 'Username exists.'
                            $('#username').val(Meteor.user().username)
                        else
                            alert "Updated username to #{username}."
    
    'keydown #contact': (e,t)->
        e.preventDefault
        contact = $('#contact').val().trim()
        switch e.which
            when 13
                if contact.length > 0
                    Meteor.call 'update_contact', contact, (err,res)->
                        unless err 
                            alert "Updated contact to #{contact}."

    'click .tag': ->
        tag = @valueOf()
        Meteor.call 'remove_tag', tag, ->
            $('#add_tag').val(tag)

    'autocompleteselect #add_tag': (event, template, doc) ->
        # console.log 'selected ', doc
        Meteor.call 'add_tag', doc.name, ->
            $('#add_tag').val ''