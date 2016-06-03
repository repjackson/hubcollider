Template.smallProfile.helpers
    isUser: -> @_id is Meteor.userId()

    myTags: ->
        _.findWhere(Meteor.user().userTags, uId: @_id)?.tags

    userTagClass: ->
        if @valueOf() in selectedUserTags.array() then 'primary' else 'basic'

    hasTagged: ->
        if @taggers and Meteor.userId() in @taggers then true else false

    doc_tag_class: ->
        result = ''
        if @valueOf() in selected_tags.array() then result += ' primary' else result += ' basic'
        # if Meteor.userId() in Template.parentData(1).up_voters then result += ' green'
        # else if Meteor.userId() in Template.parentData(1).down_voters then result += ' red'
        return result


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

    'click .doc_tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()


    'click .tagUser': ->
        console.log @
        Meteor.call 'tag_user', @user._id

    'click .removeMyTag': ->
        # console.log Template.currentData()._id
        Meteor.call 'removeUserTag', Template.currentData()._id, @valueOf()