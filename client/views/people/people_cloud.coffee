Template.people_cloud.onCreated ->
    @autorun -> Meteor.subscribe 'tags', selected_people_tags.array(), 'people'


Template.people_cloud.helpers
    all_people_tags: ->
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

    selected_people_tags: -> selected_people_tags.list()



Template.people_cloud.events
    'click .select_people_tag': -> selected_people_tags.push @name

    'click .unselect_people_tag': -> selected_people_tags.remove @valueOf()

    'click #clear_people_tags': -> selected_people_tags.clear()
