Docs.allow
    insert: (userId, doc)-> doc.author_id is Meteor.userId()
    update: (userId, doc)-> doc.author_id is Meteor.userId()
    remove: (userId, doc)-> doc.author_id is Meteor.userId()
