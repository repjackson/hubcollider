publicAccessible = FlowRouter.group({})

signInRequired = FlowRouter.group(triggersEnter: [ AccountsTemplates.ensureSignedIn ])

# signInRequired.route '/',
#     name: 'feed'
#     action: ->
#         BlazeLayout.render 'layout', main: 'feed'
#         setTitle 'Feed'

signInRequired.route '/update-profile',
    name: 'updateProfile'
    action: ->
        BlazeLayout.render 'layout', main: 'updateProfile'
        setTitle 'Update profile'

signInRequired.route '/users/:_id',
    name: 'profile'
    action: ->
        BlazeLayout.render 'layout', main: 'profile'
        setTitle 'Profile'


signInRequired.route '/',
    name: 'docs'
    action: ->
        BlazeLayout.render 'layout', main: 'docs'
        setTitle 'Docs'


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
