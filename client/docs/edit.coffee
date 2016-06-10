Template.edit.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('docId')


Template.edit.onRendered ->
    docId = FlowRouter.getParam('docId')

    # @autorun ->
    #     if GoogleMaps.loaded()
    #         $('#place').geocomplete().bind 'geocode:result', (event, result) ->
    #             console.log JSON.stringify(result, null, 4)
    #             Meteor.call 'updatelocation', docId, result, ->


Template.edit.helpers
    doc: ->
        docId = FlowRouter.getParam('docId')
        Docs.findOne docId

    hub_doc_tags: -> _.without(@tags, 'hubcollider')


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
                    FlowRouter.go '/'

        # $('.modal.delete_modal').modal(
        #     onApprove: ->
        #         Meteor.call 'delete_doc', FlowRouter.getParam('docId'), ->
        #         $('.ui.modal').modal('hide')
        #         FlowRouter.go '/'
        # 	).modal 'show'


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
        address = $('#address').val()
        img_url = $('#img_url').val()
        Docs.update FlowRouter.getParam('docId'),
            $set:
                img_url: img_url
                price: price
                address: address
                title: title
                body: body
                tagCount: @tags.length
        selected_tags.clear()
        for tag in @tags
            selected_tags.push tag
        FlowRouter.go '/'


    'click .clearDT': ->
        tagsWithoutDate = _.difference(@tags, @datearray)
        Docs.update FlowRouter.getParam('docId'),
            $set:
                tags: tagsWithoutDate
                datearray: []
                dateTime: null
        $('#datetimepicker').val('')

    'click .clearAddress': ->
        tagsWithoutAddress = _.difference(@tags, @addresstags)
        Docs.update FlowRouter.getParam('docId'),
            $set:
                tags: tagsWithoutAddress
                addresstags: []
                locationob: null
        $('#place').val('')


    'keyup #title': ->
        title = $('#title').val()
        Docs.update FlowRouter.getParam('docId'),
            $set:
                title: title


    update_address = ->

    'keyup #address': (e,t)->
        address = $('#address').val()
        old_address = @address
        switch e.which
            when 13
                Docs.update FlowRouter.getParam('docId'),
                    $addToSet: tags: address
                Docs.update FlowRouter.getParam('docId'),
                    $pull: tags: old_address
                Docs.update FlowRouter.getParam('docId'),
                    $set: address: address

        # _.debounce(update_address, 300)

