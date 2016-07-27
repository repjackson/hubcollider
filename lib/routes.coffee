publicAccessible = FlowRouter.group({})

signInRequired = FlowRouter.group(triggersEnter: [ AccountsTemplates.ensureSignedIn ])


FlowRouter.route '/',
    name: 'home'
    action: ->
        BlazeLayout.render 'layout', main: 'home'
        setTitle 'Home'


FlowRouter.route '/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'doc_page'

FlowRouter.route '/docs',
    name: 'docs'
    action: ->
        BlazeLayout.render 'layout', main: 'docs'
        setTitle 'docs'

signInRequired.route '/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_doc'
