Template.card.onCreated ->
    # console.log @data.authorId
    Meteor.subscribe 'person', @data.authorId


Template.card.onRendered ->
    # $('.special.cards .blurring.dimmable.image').dimmer({
    #   on: 'hover'
    # });

    # Meteor.setTimeout (->
    #     $('.shape').shape();
    #     ), 300



Template.card.helpers
    isAuthor: -> @authorId is Meteor.userId()

    when: -> moment(@timestamp).fromNow()

    clipped_hub_tags: -> _.without(@tags, 'hubcollider').slice(0,5)

    doc_tag_class: ->
        result = ''
        if @valueOf() in selected_tags.array() then result += ' primary' else result += ' basic'
        # if Meteor.userId() in Template.parentData(1).up_voters then result += ' green'
        # else if Meteor.userId() in Template.parentData(1).down_voters then result += ' red'
        return result

    select_author_button_class: -> if @authorId in selected_authors.array() then 'primary' else 'basic'

    cloud_label_class: -> if @name in selected_tags.array() then 'primary' else 'basic'

    vote_up_button_class: ->
        if not Meteor.userId() then 'disabled basic'
        else if Meteor.userId() in @up_voters then 'green'
        else 'basic'

    vote_down_button_class: ->
        if not Meteor.userId() then 'disabled basic'
        else if Meteor.userId() in @down_voters then 'red'
        else 'basic'


Template.card.events
    'click .doc_title': -> FlowRouter.go "/view/#{@_id}"

    'click .editDoc': ->
        FlowRouter.go "/edit/#{@_id}"
        # Session.set('is_editing', @_id)
        # # console.log @
        # $(".modal.view_doc").modal(
        #     onApprove: ->
        #         $('.ui.modal').modal('hide')
        # 	).modal 'show'

    'click .doc_tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()

    'click .select_author': ->
        if @authorId in selected_authors.array() then selected_authors.remove @authorId else selected_authors.push @authorId

    # 'click .cloneDoc': ->
    #     # if confirm 'Clone?'
    #     id = Docs.insert
    #         tags: @tags
    #         body: @body
    #     FlowRouter.go "/edit/#{id}"

    # 'click .select_user': ->
    #     if Session.equals('selected_user', @authorId) then Session.set('selected_user', null) else Session.set('selected_user', @authorId)

    # 'click .make_big': ->
    #     # Session.set('is_big', @_id)
    #     # console.log @
    #     $(".modal.#{@_id}").modal(
    #         onApprove: ->
    #             $('.ui.modal').modal('hide')
    #     	).modal 'show'

    'click .vote_down': -> Meteor.call 'vote_down', @_id

    'click .vote_up': -> Meteor.call 'vote_up', @_id