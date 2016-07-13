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


signInRequired.route '/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'doc_page'

signInRequired.route '/docs',
    name: 'docs'
    action: ->
        BlazeLayout.render 'layout', main: 'docs'
        setTitle 'docs'

signInRequired.route '/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_doc'



# People
signInRequired.route '/people',
    name: 'people'
    action: ->
        BlazeLayout.render 'layout', main: 'people'
        setTitle 'People'
