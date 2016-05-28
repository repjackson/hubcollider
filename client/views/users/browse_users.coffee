Template.browseUsers.onCreated ->
    @searchQuery = new ReactiveVar('')
    @limit = new ReactiveVar(20)
    @usersCount = new ReactiveVar(0)
    @autorun =>
        # Meteor.subscribe 'users.all', @searchQuery.get(), @limit.get()
        Meteor.subscribe 'filtered_people', selected_tags.array()
        @usersCount.set Counts.get('users.all')


Template.browseUsers.events
    'click [data-id=load-more]': (event, template) ->
        template.limit.set template.limit.get() + 20

    'keyup [data-id=search-query]': _.debounce(((event, template) ->
        event.preventDefault()
        template.searchQuery.set template.find('[data-id=search-query]').value
        template.limit.set 20
    ), 300)

    'submit [data-id=search-users-form]': (event, template) ->
        event.preventDefault()

Template.browseUsers.helpers
    users: ->
        Meteor.users.find { _id: $ne: Meteor.userId() }, sort: createdAt: -1
    hasMoreUsers: ->
        Template.instance().limit.get() <= Template.instance().usersCount.get()

