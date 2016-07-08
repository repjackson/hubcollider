publicAccessible = FlowRouter.group({})

signInRequired = FlowRouter.group(triggersEnter: [ AccountsTemplates.ensureSignedIn ])


# signInRequired.route '/profile',
#     name: 'profile'
#     action: ->
#         BlazeLayout.render 'layout', main: 'profile'
#         setTitle 'Profile'

signInRequired.route '/users/:user_id',
    name: 'profile'
    action: ->
        BlazeLayout.render 'layout', main: 'profile'
        setTitle 'Profile'


signInRequired.route '/',
    name: 'home'
    action: ->
        BlazeLayout.render 'layout', main: 'home'
        setTitle 'Home'


signInRequired.route '/messages',
    name: 'messages'
    action: ->
        BlazeLayout.render 'layout', main: 'messages'
        setTitle 'Messages'

signInRequired.route '/edit/:docId', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit'

signInRequired.route '/view/:docId', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'doc_page'



# Jobs

signInRequired.route '/jobs',
    name: 'jobs'
    action: ->
        BlazeLayout.render 'layout', main: 'jobs'
        setTitle 'Jobs'

signInRequired.route '/jobs/edit/:job_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_job'

signInRequired.route '/jobs/view/:job_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_job'



# Events

signInRequired.route '/events',
    name: 'events'
    action: ->
        BlazeLayout.render 'layout', main: 'events'
        setTitle 'Events'

signInRequired.route '/events/edit/:event_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_event'

signInRequired.route '/events/view/:event_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_event'


# Feed

signInRequired.route '/feed',
    name: 'feed'
    action: ->
        BlazeLayout.render 'layout', main: 'feed'
        setTitle 'Feed'

signInRequired.route '/posts/edit/:post_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_post'

signInRequired.route '/posts/view/:post_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_post'



# People
signInRequired.route '/people',
    name: 'people'
    action: ->
        BlazeLayout.render 'layout', main: 'people'
        setTitle 'People'