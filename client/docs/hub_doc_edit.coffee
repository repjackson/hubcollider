Template.edit.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('docId')


Template.edit.onRendered ->
    docId = FlowRouter.getParam('docId')
    Meteor.setTimeout (->
        $('#body').froalaEditor
            height: 400
            toolbarButtonsXS: ['bold', 'italic', 'fontFamily', 'fontSize', 'undo', 'redo', 'insertImage']

        ), 400



Template.edit.helpers
    doc: ->
        docId = FlowRouter.getParam('docId')
        Docs.findOne docId

    hub_doc_tags: -> _.without(@tags, 'hubcollider')


Template.edit.events
    'click #delete': ->
        $('.modal').modal(
            onApprove: ->
                Meteor.call 'deleteDoc', FlowRouter.getParam('docId'), ->
                $('.ui.modal').modal('hide')
                FlowRouter.go '/'
        	).modal 'show'


    'keydown #addTag': (e,t)->
        e.preventDefault
        tag = $('#addTag').val().toLowerCase().trim()
        switch e.which
            when 13
                if tag.length > 0
                    Docs.update FlowRouter.getParam('docId'),
                        $addToSet: tags: tag
                    $('#addTag').val('')
                else
                    body = $('#body').val()
                    Docs.update FlowRouter.getParam('docId'),
                        $set:
                            body: body
                            tagCount: @tags.length
                    selected_tags.clear()
                    for tag in @tags
                        selected_tags.push tag
                    FlowRouter.go '/'

    'click .docTag': ->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('docId'),
            $pull: tags: tag
        $('#addTag').val(tag)



    'click #saveDoc': ->
        body = $('#body').val()
        title = $('#title').val()
        price = $('#price').val()
        img_url = $('#img_url').val()
        Docs.update FlowRouter.getParam('docId'),
            $set:
                img_url: img_url
                price: price
                title: title
                body: body
                tagCount: @tags.length
        selected_tags.clear()
        for tag in @tags
            selected_tags.push tag
        FlowRouter.go '/'

    'keyup #url': (e,t)->
        docId = FlowRouter.getParam('docId')
        url = $('#url').val()
        switch e.which
            when 13
                if url.length > 0
                    Docs.update docId,
                        $set: url: url
                    Meteor.call 'fetchUrlTags', docId, url

