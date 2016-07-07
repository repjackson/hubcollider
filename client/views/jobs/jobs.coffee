@selected_job_tags = new ReactiveArray []

Template.jobs.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'jobs', selected_job_tags.array()
    

Template.jobs.helpers
    jobs: -> Docs.find()



Template.jobs.events
    'click #add_job': ->
        Meteor.call 'add_job', (err, id)->
            if err then console.error err
            else FlowRouter.go "/jobs/edit/#{id}"


Template.view_job.helpers
    is_author: -> Meteor.userId() and Meteor.userId() is @authorId 

Template.view_job.events
    'click .edit_job': -> FlowRouter.go "/jobs/edit/#{@_id}"