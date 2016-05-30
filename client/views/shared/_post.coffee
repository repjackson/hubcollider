Template.post.onCreated ->
    @searchQuery = new ReactiveVar('')
    @filter = new ReactiveVar('all')
    @limit = new ReactiveVar(20)
    @autorun =>
        @subscribe 'posts.all', @searchQuery.get(), @filter.get(), @limit.get()

Template.post.events
    'click [data-id=remove-post]': (event, template) ->
        self = this
        # Sweet Alert delete confirmation
        swal {
            title: 'Delete post?'
            text: 'Confirm delete?'
            type: 'error'
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'No'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Meteor.call 'posts.remove', self._id, (error, result) ->
                if error
                    Bert.alert error.reason, 'danger', 'growl-top-right'
                else
                    Bert.alert 'Post successfully removed', 'success', 'growl-top-right'

    'click [data-id=like-post]': (event, template) ->
        self = this
        Meteor.call 'posts.like', self._id, (error, result) ->
            if error
                Bert.alert error.reason, 'danger', 'growl-top-right'


Template.post.helpers
    author: ->
        Meteor.users.findOne _id: @authorId

    belongsPostToUser: ->
        @authorId == Meteor.userId()

    formatDate: (date) ->
        currDate = moment(new Date)
        msgDate = moment(new Date(date))
        diff = currDate.diff(msgDate, 'days')
        if diff == 0 and currDate.day() == msgDate.day()
            hourDiff = currDate.diff(msgDate, 'hours')
            minDiff = currDate.diff(msgDate, 'minutes')
            if hourDiff > 0
                if hourDiff == 1
                    hourDiff + ' hr'
                else
                    hourDiff + ' hrs'
            else if minDiff > 0
                if minDiff == 1
                    minDiff + ' min'
                else
                    minDiff + ' mins'
            else
                'Just now'
        else if diff <= 1 and currDate.day() != msgDate.day()
            'Yesterday at ' + moment(date).format('h:mm a')
        else
            if currDate.year() != msgDate.year()
                moment(date).format 'MMMM DD, YYYY'
            else
                moment(date).format('MMMM DD') + ' at ' + moment(date).format('h:mm a')

    isLiked: ->
        if Posts.find(
                _id: @_id
                already_voted: $in: [ Meteor.userId() ]).count() == 1
            return 'liked'
        ''