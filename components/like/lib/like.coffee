Meteor.methods
    like: (doc)->
        if doc.likers and Meteor.userId() in doc.likers
            Docs.update doc._id,
                $pull: likers: Meteor.userId()
                $inc: like_count: -1
        else
            Docs.update doc._id,
                $addToSet: likers: Meteor.userId()
                $inc: like_count: 1