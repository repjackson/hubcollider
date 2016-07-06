signInRequired = FlowRouter.group(triggersEnter: [ AccountsTemplates.ensureSignedIn ])


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
