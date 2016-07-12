Meteor.methods
    update_username: (username)->
        existing_user = Meteor.users.findOne username:username
        if existing_user then throw new Meteor.Error 500, 'Username exists'
        else
            Meteor.users.update Meteor.userId(),
                $set: username: username
                
                
@Features = ['recipe', 'review']
