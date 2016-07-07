publicAccessible = FlowRouter.group({})

signInRequired = FlowRouter.group(triggersEnter: [ AccountsTemplates.ensureSignedIn ])


signInRequired.route '/profile',
    name: 'profile'
    action: ->
        BlazeLayout.render 'layout', main: 'profile'
        setTitle 'Profile'

signInRequired.route '/users/:_id',
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
