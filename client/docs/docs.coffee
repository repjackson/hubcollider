Template.docs.onCreated ->
    @autorun -> Meteor.subscribe 'docs', selected_tags.array(), selected_authors.array()
    Session.setDefault('is_big', null)


Template.docs.helpers
    docs: -> Docs.find {},
        # limit: 5
        sort:
            timestamp: -1
    # docs: -> Docs.find()

Template.docs.helpers
    is_big: ->
        Session.equals('is_big', @_id)