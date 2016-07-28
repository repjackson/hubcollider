@selected_tags = new ReactiveArray []

Template.cloud.onCreated ->
    @autorun -> Meteor.subscribe 'tags', selected_tags.array()


Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'

    

Template.cloud.helpers
    all_tags: ->
        docCount = Docs.find().count()
        if 0 < docCount < 3 then Tags.find { count: $lt: docCount } else Tags.find()
        # Tags.find()

    cloud_tag_class: ->
        buttonClass = switch
            when @index <= 5 then 'large'
            when @index <= 10 then ''
            when @index <= 15 then 'small'
            when @index <= 20 then 'tiny'
        return buttonClass

    selected_tags: -> selected_tags.list()


Template.docs.onCreated ->
    @autorun -> Meteor.subscribe('docs', selected_tags.array())


Template.docs.helpers
    docs: -> 
        # Docs.find({ _id: $ne: Meteor.userId() })
        Docs.find({ })

    tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else ''


Template.cloud.events
    'click .select_tag': -> selected_tags.push @name

    'click .unselect_tag': -> selected_tags.remove @valueOf()

    'click #clear_tags': -> selected_tags.clear()




Template.cloud.events
    'click #add_doc': ->
        Meteor.call 'add_doc', (err, id)->
            if err then console.error err
            else FlowRouter.go "/edit/#{id}"





Template.edit.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('doc_id')
        # self.subscribe 'tags', selected_type_of_event_tags.array(),"event"



Template.edit.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    

Template.edit.onRendered ->
    Meteor.setTimeout (->
        $('#body').froalaEditor
            heightMin: 200
            # toolbarInline: true
            # toolbarButtonsMD: ['bold', 'italic', 'fontSize', 'undo', 'redo', '|', 'insertImage', 'insertVideo','insertFile']
            # toolbarButtonsSM: ['bold', 'italic', 'fontSize', 'undo', 'redo', '|', 'insertImage', 'insertVideo','insertFile']
            # toolbarButtonsXS: ['bold', 'italic', 'fontSize', 'undo', 'redo', '|', 'insertImage', 'insertVideo','insertFile']
            toolbarButtons: 
                [
                  'fullscreen'
                  'bold'
                  'italic'
                  'underline'
                  'strikeThrough'
                  'subscript'
                  'superscript'
                #   'fontFamily'
                #   'fontSize'
                  '|'
                  'color'
                  'emoticons'
                #   'inlineStyle'
                #   'paragraphStyle'
                  '|'
                  'paragraphFormat'
                  'align'
                  'formatOL'
                  'formatUL'
                  'outdent'
                  'indent'
                  'quote'
                  'insertHR'
                  '-'
                  'insertLink'
                  'insertImage'
                  'insertVideo'
                  'insertFile'
                  'insertTable'
                  'undo'
                  'redo'
                  'clearFormatting'
                  'selectAll'
                  'html'
                ]
        ), 500


        
Template.edit.events
    'click #delete_doc': ->
        swal {
            title: 'Delete doc?'
            # text: 'Confirm delete?'
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
                    FlowRouter.go '/'

    'keydown #add_tag': (e,t)->
        switch e.which
            when 13
                doc_id = FlowRouter.getParam('doc_id')
                tag = $('#add_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Docs.update doc_id,
                        $addToSet: tags: tag
                    $('#add_tag').val('')
                    
    'click .doc_tag': (e,t)->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        tag = @valueOf()
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: tags: tag
        $('#add_tag').val(tag)


    'click #save_doc': ->
        body = $('#body').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set:
                body: body
                tag_count: @tags.length
        selected_tags.clear()
        for tag in @tags
            selected_tags.push tag
        FlowRouter.go '/'




Template.view.events
    'click .doc_tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())


    'click .edit_doc': -> FlowRouter.go "/edit/#{@_id}"
