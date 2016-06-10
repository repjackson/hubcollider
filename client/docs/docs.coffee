Template.docs.onCreated ->
    @autorun -> Meteor.subscribe 'docs', selected_tags.array(), selected_authors.array()
    Session.setDefault('is_editing', null)


Template.docs.helpers
    docs: -> Docs.find {},
        # limit: 5
        sort:
            points: 1
            timestamp: -1
    # docs: -> Docs.find()

Template.docs.helpers
    is_editing: -> Session.equals('is_editing', @_id)