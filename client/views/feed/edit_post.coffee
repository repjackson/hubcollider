Template.edit.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('docId')


Template.edit.onRendered ->
#     docId = FlowRouter.getParam('docId')
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


Template.edit.helpers
    doc: ->
        # docId = FlowRouter.getParam('docId')
        Docs.findOne FlowRouter.getParam('docId')

    unpicked_alchemy_tags: -> _.difference @alchemy_tags, @tags
    unpicked_yaki_tags: -> _.difference @yaki_tags, @tags

Template.edit.events
    'click #alchemy_suggest': ->
        Docs.update FlowRouter.getParam('docId'),
            $set: body: $('#body').val()
        Meteor.call 'alchemy_suggest', FlowRouter.getParam('docId')

    'click #yaki_suggest': ->
        Docs.update FlowRouter.getParam('docId'),
            $set: body: $('#body').val()
        Meteor.call 'yaki_suggest', FlowRouter.getParam('docId')


    'click .add_alchemy_suggestion': ->
        docId = FlowRouter.getParam('docId')
        Docs.update docId, $addToSet: tags: @valueOf()

    'click .add_yaki_suggestion': ->
        docId = FlowRouter.getParam('docId')
        Docs.update docId, $addToSet: tags: @valueOf()

    'click #add_all_alchemy': ->
        docId = FlowRouter.getParam('docId')
        Docs.update docId,
            $addToSet: tags: $each: @alchemy_tags

    'click #add_all_yaki': ->
        docId = FlowRouter.getParam('docId')
        Docs.update docId,
            $addToSet: tags: $each: @yaki_tags


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
                    console.error error.reason
                else
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
        Docs.update FlowRouter.getParam('docId'),
            $set:
                body: body
                # tagCount: @tags.length
        Meteor.call 'generate_person_cloud'
        FlowRouter.go '/'
        selected_tags.clear()
        for tag in tags
            selected_tags.push tag


