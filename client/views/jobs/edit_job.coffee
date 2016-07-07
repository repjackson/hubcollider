Template.edit_job.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'job', FlowRouter.getParam('doc_id')



# Template.edit_job.onRendered ->

Template.edit_job.helpers
    job: ->
        # docId = FlowRouter.getParam('doc_id')
        Docs.findOne FlowRouter.getParam('doc_id')

    type_button_class: (type)->
        if @type is type.hash.type then 'active' else 'basic'



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
            Meteor.call 'delete_job', FlowRouter.getParam('doc_id'), (error, result) ->
                if error
                    console.error error.reason
                else
                    FlowRouter.go '/jobs'


    'keydown #add_job_tag': (e,t)->
        switch e.which
            when 13
                doc_id = FlowRouter.getParam('doc_id')
                tag = $('#add_job_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Docs.update doc_id,
                        $addToSet: tags: tag
                    $('#add_job_tag').val('')

    'click .job_tag': (e,t)->
        job = Docs.findOne FlowRouter.getParam('doc_id')
        tag = @valueOf()
        if tag is job.type
            Docs.update FlowRouter.getParam('doc_id'),
                $set: type: ''
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: tags: tag
        $('#add_job_tag').val(tag)


    'click .type_button': (e,t)->
        current_type = @type
        type = e.currentTarget.innerHTML.trim().toLowerCase()
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: tags: current_type
        Docs.update FlowRouter.getParam('doc_id'),
            $set: type: type
            $addToSet: tags: type

    'click #save_job': ->
        description = $('#description').val()
        Docs.update FlowRouter.getParam('doc_id'),
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
            Docs.update FlowRouter.getParam('doc_id'),
                $set: title: title
