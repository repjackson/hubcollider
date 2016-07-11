Template.registerHelper 'instance', ->
    Template.instance()

Template.registerHelper 'when', -> moment(@timestamp).fromNow()
