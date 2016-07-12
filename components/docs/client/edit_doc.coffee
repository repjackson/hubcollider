selected_type_of_doc_tags = new ReactiveArray []

Template.edit_doc.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('doc_id')
        # self.subscribe 'tags', selected_type_of_event_tags.array(),"event"



Template.edit_doc.helpers
    doc: ->
        # docId = FlowRouter.getParam('doc_id')
        Docs.findOne FlowRouter.getParam('doc_id')
    
    availableparts: -> _.difference(Features, @partlist)
    templateEditName: -> @+'_edit'
    subtemplatecontext: ->
        part = Session.get 'selectedpart'
        console.log @parts?.part
        #Template.parentData(1).parts?[this]
    template_name: -> "#{@}"

    # type_button_class: (type)->
    #     # console.log type.hash.type.toString() 
    #     if @type is type.hash.type.toString() then 'active' else 'basic'

    features: -> Features

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
    type_of_event_cloud: -> Tags.find()
    
    # selected_type_of_event_tags: -> selected_type_of_event_tags.array()
        
        
Template.edit_doc.events
    'click #delete_doc': ->
        swal {
            title: 'Delete doc?'
            text: 'Confirm delete?'
            type: 'error'
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'No'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Meteor.call 'delete_doc', FlowRouter.getParam('doc_id'), (error, result) ->
                if error
                    console.error error.reason
                else
                    FlowRouter.go '/docs'

    # 'autocompleteselect #add_type_of_doc_tag': (event, template, doc) ->
    #     # console.log 'selected ', doc
    #   Docs.update FlowRouter.getParam("doc_id"), 
    #         $addToSet: tags: doc.name
    #     $('#add_type_of_doc_tag').val('')
    #     selected_type_of_doc_tags.push doc.name

    'click .add_component': (e,t)->
        component = e.currentTarget.attributes.id.nodeValue
        Meteor.call 'add_component', FlowRouter.getParam('doc_id'), component

    'keydown #add_doc_tag': (e,t)->
        switch e.which
            when 13
                doc_id = FlowRouter.getParam('doc_id')
                tag = $('#add_doc_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Docs.update doc_id,
                        $addToSet: tags: tag
                    $('#add_doc_tag').val('')
                    
    # 'keydown #add_type_of_doc_tag': (e,t)->
    #     switch e.which
    #         when 13
    #             doc_id = FlowRouter.getParam('doc_id')
    #             tag = $('#add_type_of_doc_tag').val().toLowerCase().trim()
    #             if tag.length > 0
    #                 Docs.update doc_id,
    #                     $addToSet: tags: tag
    #                 $('#add_type_of_doc_tag').val('')

    'click .doc_tag': (e,t)->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        tag = @valueOf()
        if tag is doc.type
            Docs.update FlowRouter.getParam('doc_id'),
                $set: type: ''
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: tags: tag
        $('#add_doc_tag').val(tag)


    # 'click .type_button': (e,t)->
    #     current_type = @type
    #     machine_type = e.currentTarget.id
    #     type = e.currentTarget.innerHTML.trim().toLowerCase()
    #     Docs.update FlowRouter.getParam('doc_id'),
    #         $pull: tags: current_type
    #     Docs.update FlowRouter.getParam('doc_id'),
    #         $set: type: machine_type
    #         $addToSet: tags: type

    'click #save_doc': ->
        description = $('#description').val()
        datetime = $('#datetimepicker').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set:
                description: description
                datetime: datetime
                # tagCount: @tags.length
        # selected_doc_tags.clear()
        # for tag in tags
        #     selected_doc_tags.push tag
        FlowRouter.go '/docs'


    # 'click .select_type_of_doc_tag': -> 
    #     selected_type_of_doc_tags.push @name
    #     Docs.update FlowRouter.getParam("doc_id"), 
    #         $addToSet: tags: @name

    # 'click .unselect_type_of_doc_tag': -> 
    #     selected_type_of_doc_tags.remove @valueOf()

    # 'click #clear_type_of_doc_tags': -> 
    #     selected_type_of_doc_tags.clear()


    # 'blur #title': ->
    #     title = $('#title').val()
    #     # if title.length is 0
    #     #     Bert.alert 'Must include title', 'danger', 'growl-top-right'
    #     # else
    #     Docs.update FlowRouter.getParam('doc_id'),
    #         $set: title: title

    # 'change [name="upload_image"]': (doc, template) ->
    #     id = FlowRouter.getParam('doc_id')
    #     # template.uploading.set true
    #     console.log doc.target.files
    #     uploader = new (Slingshot.Upload)('myFileUploads')
    #     uploader.send doc.target.files[0], (error, downloadUrl) ->
    #         if error
    #             # Log service detailed response.
    #             # console.error 'Error uploading', uploader.xhr.response
    #             console.error 'Error uploading', error
    #             alert error
    #         else
    #             Meteor.users.update Meteor.userId(), $push: 'profile.files': downloadUrl
    #             Docs.update id, $set: downloadUrl: downloadUrl
    #         return



Template.edit_doc.onRendered ->
    Meteor.setTimeout (->
        $('#datetimepicker').datetimepicker()
        ), 500
