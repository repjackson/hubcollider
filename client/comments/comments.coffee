Template.comments.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'comments.doc', Template.currentData()._id


Template.comments.helpers
    comments: ->
        Comments.find {doc_id: @_id},
            sort:
                timestamp: -1



Template.comments.events
    'click .add_comment': (e,t)->
        text = t.$('#comment_area').val()
        Meteor.call 'comments.insert', @_id, text