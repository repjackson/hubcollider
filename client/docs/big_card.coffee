Template.big_card.onCreated ->
    # console.log @data.authorId
    Meteor.subscribe 'person', @data.authorId

Template.big_card.onRendered ->
    # $('.special.cards .image').dimmer({
    #   on: 'hover'
    # });



Template.big_card.helpers
    doc_card_class: ->
        if 'academy' in @tags then return 'yellow'
        if 'economy' in @tags then return 'green'

    is_in_academy: -> 'academy' in @tags

    is_in_economy: -> 'economy' in @tags

    isAuthor: -> @authorId is Meteor.userId()

    when: -> moment(@timestamp).fromNow()

    hub_tags: -> _.without(@tags, 'hubcollider')

    doc_tag_class: ->
        result = ''
        if @valueOf() in selected_tags.array() then result += ' primary' else result += ' basic'
        # if Meteor.userId() in Template.parentData(1).up_voters then result += ' green'
        # else if Meteor.userId() in Template.parentData(1).down_voters then result += ' red'
        return result

    select_author_button_class: -> if @authorId in selected_authors.array() then 'primary' else 'basic'

    cloud_label_class: -> if @name in selected_tags.array() then 'primary' else 'basic'



Template.big_card.events
    'click .doc_title': -> FlowRouter.go "/view/#{@_id}"

    'click .editDoc': ->
        # FlowRouter.go "/edit/#{@_id}"
        $('.big_card').transition 'horizontal flip'
        Session.set('is_editing', @_id)

    'click .doc_tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()

    'click .select_author': ->
        if @authorId in selected_authors.array() then selected_authors.remove @authorId else selected_authors.push @authorId

    'click .cloneDoc': ->
        # if confirm 'Clone?'
        id = Docs.insert
            tags: @tags
            body: @body
        FlowRouter.go "/edit/#{id}"

    'click .select_user': ->
        if Session.equals('selected_user', @authorId) then Session.set('selected_user', null) else Session.set('selected_user', @authorId)


    'click .make_small': ->
        $('.ui.modal').modal('hide')
