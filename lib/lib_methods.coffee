Meteor.methods
    # vote_up: (id)->
    #     doc = Docs.findOne id
    #     if not doc.up_voters
    #         Docs.update id,
    #             $addToSet: up_voters: []
    #             $inc: points: 0

    #     if Meteor.userId() in doc.up_voters #undo upvote
    #         Docs.update id,
    #             $pull: up_voters: Meteor.userId()
    #             $inc: points: -1
    #         # Meteor.users.update doc.authorId, $inc: points: -1
    #         # Meteor.users.update Meteor.userId(), $inc: points: 1

    #     else if Meteor.userId() in doc.down_voters #switch downvote to upvote
    #         Docs.update id,
    #             $pull: down_voters: Meteor.userId()
    #             $addToSet: up_voters: Meteor.userId()
    #             $inc: points: 2
    #         # Meteor.users.update doc.authorId, $inc: points: 2
    #     else #clean upvote
    #         Docs.update id,
    #             $addToSet: up_voters: Meteor.userId()
    #             $inc: points: 1
    #         # Meteor.users.update doc.authorId, $inc: points: 1
    #         # Meteor.users.update Meteor.userId(), $inc: points: -1

    #     Meteor.call 'generatePersonalCloud', Meteor.userId()

    # vote_down: (id)->
    #     doc = Docs.findOne id
    #     if not doc.down_voters
    #         Docs.update id,
    #             $addToSet: down_voters: []
    #             $inc: points: 0
    #     if Meteor.userId() in doc.down_voters #undo downvote
    #         Docs.update id,
    #             $pull: down_voters: Meteor.userId()
    #             $inc: points: 1
    #         # Meteor.users.update doc.authorId, $inc: points: 1
    #         # Meteor.users.update Meteor.userId(), $inc: points: 1

    #     else if Meteor.userId() in doc.up_voters #switch upvote to downvote
    #         Docs.update id,
    #             $pull: up_voters: Meteor.userId()
    #             $addToSet: down_voters: Meteor.userId()
    #             $inc: points: -2
    #         # Meteor.users.update doc.authorId, $inc: points: -2

    #     else #clean downvote
    #         Docs.update id,
    #             $addToSet: down_voters: Meteor.userId()
    #             $inc: points: -1
    #         # Meteor.users.update doc.authorId, $inc: points: -1
    #         # Meteor.users.update Meteor.userId(), $inc: points: -1
    #     Meteor.call 'generatePersonalCloud', Meteor.userId()

    update_username: (username)->
        existing_user = Meteor.users.findOne username:username
        if existing_user then throw new Meteor.Error 500, 'Username exists'
        else
            Meteor.users.update Meteor.userId(),
                $set: username: username