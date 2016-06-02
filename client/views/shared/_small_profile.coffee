Template.smallProfile.helpers
    isUser: -> @_id is Meteor.userId()

    myTags: ->
        _.findWhere(Meteor.user().userTags, uId: @_id)?.tags

    userTagClass: ->
        if @valueOf() in selectedUserTags.array() then 'primary' else 'basic'

    hasTagged: ->
        if @taggers and Meteor.userId() in @taggers then true else false


Template.smallProfile.events
    'click .userTag': ->
        if @valueOf() in selectedUserTags.array() then selectedUserTags.remove @valueOf() else selectedUserTags.push @valueOf()

    'keyup .addTag': (e,t)->
        tag = t.find('.addTag').value.toLowerCase()
        switch e.which
            when 13
                if tag.length > 0
                    Meteor.call 'addTag', @_id, tag
                    $('.addTag').val('')

    'click .tagUser': ->
        console.log @
        Meteor.call 'tag_user', @user._id

    'click .removeMyTag': ->
        # console.log Template.currentData()._id
        Meteor.call 'removeUserTag', Template.currentData()._id, @valueOf()