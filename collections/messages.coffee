Messages = new (Mongo.Collection)('messages')

Meteor.methods
    'messages.insert': (toUserId, toUsername, body) ->
        # Verify that user is logged in
        if !Meteor.user()
            throw new (Meteor.Error)(401, 'You need to be signed in to continue')
        if !toUserId
            throw new (Meteor.Error)(422, 'To field should not be blank')
        if !body
            throw new (Meteor.Error)(422, 'Body should not be blank')
        # Verify that to is an existing user
        if Meteor.users.find(_id: toUserId).count() == 0
            throw new (Meteor.Error)(111, 'Not a valid user')
        message =
            originatingFromId: Meteor.userId()
            originatingFromName: Meteor.user().username
            originatingToId: toUserId
            originatingToName: toUsername
            conversation: [ {
                from: userId: Meteor.userId()
                to:
                    userId: toUserId
                    read: false
                body: body
                sentOn: new Date
                originatingFromDeleted: false
                originatingToDeleted: false
            } ]
        Messages.insert message

    'messages.remove': (messageId, whoDeleted) ->
        `var x`
        # Verify that user is logged in
        if !Meteor.user()
            throw new (Meteor.Error)(401, 'You need to be signed in to continue')
        # Verify that message exists
        if Messages.find(_id: messageId).count() == 0
            throw new (Meteor.Error)(111, 'Not a valid message')
        # Get conversation array and store in variable
        conversation = Messages.findOne(_id: messageId).conversation
        if whoDeleted == 'from'
            x = 0
            while x < conversation.length
                conversation[x].originatingFromDeleted = true
                x++
        else if whoDeleted == 'to'
            x = 0
            while x < conversation.length
                conversation[x].originatingToDeleted = true
                x++
        else
            throw new (Meteor.Error)(211, 'Message could not be deleted')
        Messages.update { _id: messageId }, $set: conversation: conversation
        return
    
    'messages.updateRead': (messageId, val) ->
        # Verify that user is logged in
        if !Meteor.user()
            throw new (Meteor.Error)(401, 'You need to be signed in to continue')
        # Verify that message exists
        if Messages.find(_id: messageId).count() == 0
            throw new (Meteor.Error)(111, 'Not a valid message')
        # Get conversation array and store in variable
        conversation = Messages.findOne(_id: messageId).conversation
        x = 0
        while x < conversation.length
            if conversation[x].to.userId == Meteor.userId()
                conversation[x].to.read = val
            x++
        # Update entire conversation array in Messages
        Messages.update { _id: messageId }, $set: conversation: conversation
        return

    'messages.addMessage': (messageId, toUserId, body) ->
        # Verify that user is logged in
        if !Meteor.user()
            throw new (Meteor.Error)(401, 'You need to be signed in to continue')
        if !body
            throw new (Meteor.Error)(422, 'Body should not be blank')
        if !toUserId
            throw new (Meteor.Error)(422, 'Error finding other user')
        # Verify that message exists
        if Messages.find(_id: messageId).count() == 0
            throw new (Meteor.Error)(111, 'Not a valid message')
        newMessage =
            from: userId: Meteor.userId()
            to:
                userId: toUserId
                read: false
            body: body
            sentOn: new Date
            originatingFromDeleted: false
            originatingToDeleted: false
        # Add item to array
        Messages.update { _id: messageId }, $push: conversation: newMessage
        return
