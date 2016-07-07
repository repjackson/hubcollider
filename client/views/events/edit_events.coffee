Template.edit_event.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('event_id')



# Template.edit_event.onRendered ->

Template.edit_event.helpers
    event: ->
        # docId = FlowRouter.getParam('event_id')
        Docs.findOne FlowRouter.getParam('event_id')
    
    type_button_class: (type)->
        # console.log type.hash.type.toString() 
        if @type is type.hash.type.toString() then 'active' else 'basic'

Template.edit_event.events
    'click #delete': ->
        swal {
            title: 'Delete event?'
            text: 'Confirm delete?'
            type: 'error'
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'No'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Meteor.call 'delete_event', FlowRouter.getParam('event_id'), (error, result) ->
                if error
                    console.error error.reason
                else
                    FlowRouter.go '/'


    'keydown #add_event_tag': (e,t)->
        switch e.which
            when 13
                event_id = FlowRouter.getParam('event_id')
                tag = $('#add_event_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Docs.update event_id,
                        $addToSet: tags: tag
                    $('#add_event_tag').val('')

    'click .event_tag': (e,t)->
        event = Docs.findOne FlowRouter.getParam('event_id')
        tag = @valueOf()
        if tag is event.type
            Docs.update FlowRouter.getParam('event_id'),
                $set: type: ''
        Docs.update FlowRouter.getParam('event_id'),
            $pull: tags: tag
        $('#add_event_tag').val(tag)


    'click .type_button': (e,t)->
        current_type = @type
        machine_type = e.currentTarget.id
        type = e.currentTarget.innerHTML.trim().toLowerCase()
        Docs.update FlowRouter.getParam('event_id'),
            $pull: tags: current_type
        Docs.update FlowRouter.getParam('event_id'),
            $set: type: machine_type
            $addToSet: tags: type

    'click #save_event': ->
        description = $('#description').val()
        Docs.update FlowRouter.getParam('event_id'),
            $set:
                description: description
                # tagCount: @tags.length
        # selected_event_tags.clear()
        # for tag in tags
        #     selected_event_tags.push tag
        FlowRouter.go '/events'



    'blur #title': ->
        title = $('#title').val()
        if title.length is 0
            Bert.alert 'Must include title', 'danger', 'growl-top-right'
        else
            Docs.update FlowRouter.getParam('event_id'),
                $set: title: title

Template.edit_event.onRendered ->
    Meteor.setTimeout (->
        $('#datetimepicker').datetimepicker()
        ), 500
