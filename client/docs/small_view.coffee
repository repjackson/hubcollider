Template.small_view.events
    'click .view_main': (e,t)->
        t.$('.ui.shape').shape('flip right')

    'click .view_comments': (e,t)->
        t.$('.ui.shape').shape('flip left')


Template.small_view.helpers
    is_author: -> Meteor.userId() is @authorId