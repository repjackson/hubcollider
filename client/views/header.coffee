Template.header.events 'click [data-id=sign-out]': ->
    Meteor.logout (error) ->
        if error
            alert error.reason
        else
            FlowRouter.go '/sign-in'
