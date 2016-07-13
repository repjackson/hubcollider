selected_activity_tags = new ReactiveArray []

Template.activity.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'my_docs'
    

Template.activity.helpers
    my_docs: -> Docs.find()


Template.doc.helpers
    is_author: -> Meteor.userId() and Meteor.userId() is @authorId 


Template.doc.events
    
Template.activity.onCreated ->
    @autorun -> Meteor.subscribe 'my_tags', selected_people_tags.array()


Template.activity.helpers
    all_activity_tags: ->
        # docCount = Docs.find().count()
        # if 0 < docCount < 3 then Tags.find { count: $lt: docCount } else Tags.find()
        Tags.find()

    selected_activity_tags: -> selected_activity_tags.list()



Template.activity.events
    'click .select_activity_tag': -> selected_activity_tags.push @name

    'click .unselect_activity_tag': -> selected_activity_tags.remove @valueOf()

    'click #clear_activity_tags': -> selected_activity_tags.clear()
