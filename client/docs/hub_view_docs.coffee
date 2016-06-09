Template.docs.onCreated ->
    @autorun -> Meteor.subscribe 'docs', selected_tags.array(), Session.get('selected_user')

Template.docs.helpers
    docs: -> Docs.find {},
        # limit: 5
        sort:
            tagCount: 1
            timestamp: -1
    # docs: -> Docs.find()

Template.view.onCreated ->
    # console.log @data.authorId
    Meteor.subscribe 'person', @data.authorId

Template.view.helpers
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

    select_user_button_class: -> if Session.equals 'selected_user', @authorId then 'primary' else 'basic'

    cloud_label_class: -> if @name in selected_tags.array() then 'primary' else 'basic'

    # upVotedMatchCloud: ->
    #     my_upvoted_cloud = Meteor.user().upvoted_cloud
    #     myupvoted_list = Meteor.user().upvoted_list
    #     # console.log 'my_upvoted_cloud', my_upvoted_cloud
    #     # console.log @
    #     otherUser = Meteor.users.findOne @authorId
    #     other_upvoted_cloud = otherUser?.upvoted_cloud
    #     other_upvoted_list = otherUser?.upvoted_list
    #     # console.log 'otherCloud', other_upvoted_cloud
    #     intersection = _.intersection(myupvoted_list, other_upvoted_list)
    #     intersection_cloud = []
    #     totalCount = 0
    #     for tag in intersection
    #         myTagObject = _.findWhere my_upvoted_cloud, name: tag
    #         hisTagObject = _.findWhere other_upvoted_cloud, name: tag
    #         # console.log hisTagObject.count
    #         min = Math.min(myTagObject.count, hisTagObject.count)
    #         totalCount += min
    #         intersection_cloud.push
    #             tag: tag
    #             min: min
    #     sortedCloud = _.sortBy(intersection_cloud, 'min').reverse()
    #     result = {}
    #     result.cloud = sortedCloud
    #     result.totalCount = totalCount
    #     return result


Template.view.events
    'click .editDoc': -> FlowRouter.go "/edit/#{@_id}"

    'click .doc_tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()

    'click .deleteDoc': ->
        if confirm 'Delete?'
            Meteor.call 'deleteDoc', @_id

    'click .authorFilterButton': ->
        if @username in selectedUsernames.array() then selectedUsernames.remove @username else selectedUsernames.push @username

    'click .cloneDoc': ->
        # if confirm 'Clone?'
        id = Docs.insert
            tags: @tags
            body: @body
        FlowRouter.go "/edit/#{id}"

    'click .select_user': ->
        if Session.equals('selected_user', @authorId) then Session.set('selected_user', null) else Session.set('selected_user', @authorId)