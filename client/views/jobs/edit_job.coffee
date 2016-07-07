selected_field_of_work_tags = new ReactiveArray []

Template.edit_job.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('job_id')
        self.subscribe 'tags', selected_field_of_work_tags.array(),"job"



# Template.edit_job.onRendered ->

Template.edit_job.helpers
    job: ->
        # docId = FlowRouter.getParam('job_id')
        Docs.findOne FlowRouter.getParam('job_id')

    tag_suggestion_class: (val)->
        # if @type is type.hash.type.toLowerCase() then 'active' else 'basic'
        # e.currentTarget.innerHTML.trim().toLowerCase()
        if val.hash.val in @tags then 'primary' else 'basic'
    
    settings: ->
        {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    # token: ''
                    collection: Tags
                    field: 'name'
                    matchAll: true
                    template: Template.tag_result
                }
            ]
        }
        
    selected_field_of_work_tags: -> selected_field_of_work_tags.array()



Template.edit_job.events
    'click #delete_job': ->
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
                    FlowRouter.go '/jobs'


    'keydown #add_job_tag': (e,t)->
        switch e.which
            when 13
                job_id = FlowRouter.getParam('job_id')
                tag = $('#add_job_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Docs.update job_id,
                        $addToSet: tags: tag
                    $('#add_job_tag').val('')

    'keydown #add_field_of_work_tag': (e,t)->
        switch e.which
            when 13
                job_id = FlowRouter.getParam('job_id')
                tag = $('#add_field_of_work_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Docs.update job_id,
                        $addToSet: tags: tag
                    $('#add_field_of_work_tag').val('')
    
    'click .job_tag': (e,t)->
        job = Docs.findOne FlowRouter.getParam('job_id')
        tag = @valueOf()
        if tag is job.type
            Docs.update FlowRouter.getParam('job_id'),
                $set: type: ''
        Docs.update FlowRouter.getParam('job_id'),
            $pull: tags: tag
        $('#add_job_tag').val(tag)


    'click .tag_suggestion': (e,t)->
        tag = e.currentTarget.innerHTML.trim().toLowerCase()
        if tag in @tags
            Docs.update FlowRouter.getParam('job_id'),
                $pull: tags: tag
        else
            Docs.update FlowRouter.getParam('job_id'),
                $addToSet: tags: tag

    'click #save_job': ->
        description = $('#description').val()
        Docs.update FlowRouter.getParam('job_id'),
            $set:
                description: description
                # tagCount: @tags.length
        FlowRouter.go '/jobs'
        # selected_job_tags.clear()
        # for tag in tags
        #     selected_job_tags.push tag



    'blur #title': ->
        title = $('#title').val()
        if title.length is 0
            Bert.alert 'Must include title', 'danger', 'growl-top-right'
        else
            Docs.update FlowRouter.getParam('job_id'),
                $set: title: title

    'autocompleteselect #add_field_of_work_tag': (job, template, doc) ->
       Docs.update FlowRouter.getParam("job_id"), 
            $addToSet: tags: doc.name
        $('#add_field_of_work_tag').val('')
        selected_field_of_work_tags.push doc.name