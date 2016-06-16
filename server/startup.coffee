Meteor.startup ->
    # Accounts.validateNewUser (user) ->
    #     if user.emails and user.emails[0].address.length != 0
    #         return true
    #     throw new (Meteor.Error)(403, 'E-Mail address should not be blank')

    Accounts.validateNewUser (user) ->
        if user.username and user.username.length >= 3
            return true
        throw new (Meteor.Error)(403, 'Username must have at least 3 characters')
