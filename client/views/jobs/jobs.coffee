Template.edit_job.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'job', FlowRouter.getParam('jobId')


Template.edit_job.onRendered ->
#     docId = FlowRouter.getParam('job_id')
    Meteor.setTimeout (->
        $('#body').froalaEditor
            # height: 400
            heightMin: 200
            toolbarButtons: ['bold', 'italic', 'fontSize', 'undo', 'redo', '|', 'insertImage', 'insertVideo','insertFile']
            toolbarButtonsMD: ['bold', 'italic', 'fontSize', 'undo', 'redo', '|', 'insertImage', 'insertVideo','insertFile']
            toolbarButtonsSM: ['bold', 'italic', 'fontSize', 'undo', 'redo', '|', 'insertImage', 'insertVideo','insertFile']
            toolbarButtonsXS: ['bold', 'italic', 'fontSize', 'undo', 'redo', '|', 'insertImage', 'insertVideo','insertFile']

            # [
            #   'fullscreen'
            #   'bold'
            #   'italic'
            #   'underline'
            #   'strikeThrough'
            #   'subscript'
            #   'superscript'
            #   'fontFamily'
            #   'fontSize'
            #   '|'
            #   'color'
            #   'emoticons'
            #   'inlineStyle'
            #   'paragraphStyle'
            #   '|'
            #   'paragraphFormat'
            #   'align'
            #   'formatOL'
            #   'formatUL'
            #   'outdent'
            #   'indent'
            #   'quote'
            #   'insertHR'
            #   '-'
            #   'insertLink'
            #   'insertImage'
            #   'insertVideo'
            #   'insertFile'
            #   'insertTable'
            #   'undo'
            #   'redo'
            #   'clearFormatting'
            #   'selectAll'
            #   'html'
            # ]

        ), 500

Template.edit_job.helpers
    doc: ->
        # docId = FlowRouter.getParam('job_id')
        Docs.findOne FlowRouter.getParam('job_id')

    unpicked_alchemy_tags: -> _.difference @alchemy_tags, @tags
    unpicked_yaki_tags: -> _.difference @yaki_tags, @tags

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


    'keydown #add_tag': (e,t)->
        doc_id = FlowRouter.getParam('job_id')
        e.preventDefault
        tag = $('#add_tag').val().toLowerCase().trim()
        switch e.which
            when 13
                if tag.length > 0
                    Docs.update doc_id,
                        $addToSet: tags: tag
                    $('#add_tag').val('')
                # else
                #     body = $('#body').val()
                #     Docs.update doc_id,
                #         $set:
                #             body: body
                #             tagCount: @tags.length
                #     selected_tags.clear()
                #     for tag in @tags
                #         selected_tags.push tag
                #         FlowRouter.go '/'

    'click .job_tag': ->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('job_id'),
            $pull: tags: tag
        $('#add_tag').val(tag)



    'click #saveDoc': ->
        console.log 'firing savedoc'
        body = $('#body').val()
        Docs.update FlowRouter.getParam('job_id'),
            $set:
                body: body
                # tagCount: @tags.length
        Meteor.call 'generate_person_cloud'
        FlowRouter.go '/'
        selected_tags.clear()
        for tag in tags
            selected_tags.push tag


Template.jobs.events
    'click #add_job': ->
        Meteor.call 'add_job', (err, id)->
            if err then console.error err
            else FlowRouter.go "/jobs/edit/#{id}"
