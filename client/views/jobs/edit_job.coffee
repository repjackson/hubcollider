Template.edit_job.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'job', FlowRouter.getParam('job_id')



# Template.edit_job.onRendered ->

Template.edit_job.helpers
    job: ->
        # docId = FlowRouter.getParam('job_id')
        Jobs.findOne FlowRouter.getParam('job_id')


Template.edit_job.events
    'click #delete': ->
        swal {
            title: 'Delete Job?'
            text: 'Confirm delete?'
            type: 'error'
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'No'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Meteor.call 'delete_job', FlowRouter.getParam('job_id'), (error, result) ->
                if error
                    console.error error.reason
                else
                    FlowRouter.go '/'


    'keydown #add_job_tag': (e,t)->
        switch e.which
            when 13
                job_id = FlowRouter.getParam('job_id')
                tag = $('#add_job_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Jobs.update job_id,
                        $addToSet: tags: tag
                    $('#add_job_tag').val('')

    'click .job_tag': ->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('job_id'),
            $pull: tags: tag
        $('#add_job_tag').val(tag)



    'click #save_job': ->
        description = $('#description').val()
        Docs.update FlowRouter.getParam('job_id'),
            $set:
                description: description
                # tagCount: @tags.length
        FlowRouter.go '/jobs'
        selected_job_tags.clear()
        for tag in tags
            selected_job_tags.push tag



    'blur #title': ->
        title = $('#title').val()
        if title.length is 0
            Bert.alert 'Must include title', 'danger', 'growl-top-right'
        else
            Jobs.update FlowRouter.getParam('job_id'),
                $set: title: title
