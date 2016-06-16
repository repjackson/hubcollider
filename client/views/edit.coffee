Template.edit.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('docId')


Template.edit.onRendered ->
#     docId = FlowRouter.getParam('docId')
    Meteor.setTimeout (->
        $('#body').froalaEditor
            height: 400
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

        ), 300


Template.edit.helpers
    doc: ->
        # docId = FlowRouter.getParam('docId')
        Docs.findOne FlowRouter.getParam('docId')

    hub_doc_tags: -> _.without(@tags, 'hubcollider')

    unpicked_suggested_tags: ->
        _.difference @suggested_tags, @tags

Template.edit.events
    'click #delete': ->
        swal {
            title: 'Delete post?'
            text: 'Confirm delete?'
            type: 'error'
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'No'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Meteor.call 'delete_doc', FlowRouter.getParam('docId'), (error, result) ->
                if error
                    Bert.alert error.reason, 'danger', 'growl-top-right'
                else
                    Bert.alert 'Post successfully removed', 'success', 'growl-top-right'
                    # $('.ui.modal').modal('hide')
                    FlowRouter.go '/'


    'keydown #addTag': (e,t)->
        doc_id = FlowRouter.getParam('docId')
        e.preventDefault
        tag = $('#addTag').val().toLowerCase().trim()
        switch e.which
            when 13
                if tag.length > 0
                    Docs.update doc_id,
                        $addToSet: tags: tag
                    $('#addTag').val('')
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

    'click .docTag': ->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('docId'),
            $pull: tags: tag
        $('#addTag').val(tag)



    'click #saveDoc': ->
        console.log 'firing savedoc'
        body = $('#body').val()
        # title = $('#title').val()
        # price = $('#price').val()
        # address = $('#address').val()
        # img_url = $('#img_url').val()
        Docs.update FlowRouter.getParam('docId'),
            $set:
                # img_url: img_url
                # price: price
                # address: address
                # title: title
                body: body
                tagCount: @tags.length
        Meteor.call 'generate_person_cloud'
        FlowRouter.go '/'
        selected_tags.clear()
        for tag in _.without(@tags, 'hubcollider')
            selected_tags.push tag
        # Session.set('is_editing', null)
        # $('.ui.modal').modal('hide')


    # 'click .clearDT': ->
    #     tagsWithoutDate = _.difference(@tags, @datearray)
    #     Docs.update FlowRouter.getParam('docId'),
    #         $set:
    #             tags: tagsWithoutDate
    #             datearray: []
    #             dateTime: null
    #     $('#datetimepicker').val('')

    # 'click .clearAddress': ->
    #     tagsWithoutAddress = _.difference(@tags, @addresstags)
    #     Docs.update FlowRouter.getParam('docId'),
    #         $set:
    #             tags: tagsWithoutAddress
    #             addresstags: []
    #             locationob: null
    #     $('#place').val('')


    # 'blur #title': ->
    #     title = $('#title').val()
    #     if title.length is 0
    #         Bert.alert 'Must include title', 'danger', 'growl-top-right'
    #     Docs.update FlowRouter.getParam('docId'),
    #         $set:
    #             title: title


    # 'keyup #address': (e,t)->
    #     address = $('#address').val()
    #     old_address = @address
    #     switch e.which
    #         when 13
    #             Docs.update FlowRouter.getParam('docId'),
    #                 $addToSet: tags: address
    #             Docs.update FlowRouter.getParam('docId'),
    #                 $pull: tags: old_address
    #             Docs.update FlowRouter.getParam('docId'),
    #                 $set: address: address


