Template.job_cloud.onCreated ->
    @autorun -> Meteor.subscribe 'tags', selected_job_tags.array(), 'job'


Template.job_cloud.helpers
    all_job_tags: ->
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

    selected_job_tags: -> selected_job_tags.list()



Template.job_cloud.events
    'click .select_job_tag': -> selected_job_tags.push @name

    'click .unselect_job_tag': -> selected_job_tags.remove @valueOf()

    'click #clear_job_tags': -> selected_job_tags.clear()
