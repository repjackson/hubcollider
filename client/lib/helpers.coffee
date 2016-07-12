Template.registerHelper 'instance', -> Template.instance()

Template.registerHelper 'when', -> moment(@timestamp).fromNow()

Template.registerHelper 'is_author', -> Meteor.userId() and Meteor.userId() is @author_id 
