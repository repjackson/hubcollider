Session.setDefault 'editing_profile', false

Template.view_profile.events
    'click #edit_profile': -> Session.set 'editing_profile', true

Template.view_profile.helpers
    is_author: -> Meteor.userId() is FlowRouter.getParam 'user_id'

Template.profile.helpers
    is_editing_profile: -> Session.get 'editing_profile'

Template.edit_profile.helpers
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


Template.edit_profile.events
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

    'click .profile_tag': ->
        tag = @valueOf()
        Meteor.users.update Meteor.userId(),
            $pull: "profile.tags": tag
        # Meteor.call 'remove_tag', tag, ->
        #     $('#add_tag').val(tag)

    'keydown #add_profile_tag': (e,t)->
        e.preventDefault
        switch e.which
            when 13
                tag = $('#add_profile_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Meteor.users.update Meteor.userId(),
                        $addToSet: "profile.tags": tag
                    $('#add_profile_tag').val('')
                    

    'autocompleteselect #add_tag': (event, template, doc) ->
        # console.log 'selected ', doc
        Meteor.call 'add_tag', doc.name, ->
            $('#add_tag').val ''

    'click #save_profile': -> 
        description = $('#description').val()
        Meteor.users.update Meteor.userId(),
            $set:
                "profile.description": description
        Session.set 'editing_profile', false