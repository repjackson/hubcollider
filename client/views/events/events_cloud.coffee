Template.event_cloud.onCreated ->
    @autorun -> Meteor.subscribe 'tags', selected_event_tags.array(), 'event'


Template.event_cloud.helpers
    all_event_tags: ->
        # docCount = Docs.find().count()
        # if 0 < docCount < 3 then Tags.find { count: $lt: docCount } else Tags.find()
        Tags.find()

    cloud_tag_class: ->
        buttonClass = switch
            when @index <= 5 then 'large'
            when @index <= 10 then ''
            when @index <= 15 then 'small'
            when @index <= 20 then 'tiny'
        return buttonClass

    selected_event_tags: -> selected_event_tags.list()



Template.event_cloud.events
    'click .select_event_tag': -> selected_event_tags.push @name

    'click .unselect_event_tag': -> selected_event_tags.remove @valueOf()

    'click #clear_event_tags': -> selected_event_tags.clear()
