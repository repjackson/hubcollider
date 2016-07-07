Template.edit_event.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'event', FlowRouter.getParam('event_id')



# Template.edit_event.onRendered ->

Template.edit_event.helpers
    event: ->
        # docId = FlowRouter.getParam('event_id')
        Docs.findOne FlowRouter.getParam('event_id')

    type_button_class: (type)->
        if @type is type.hash.type then 'active' else 'basic'



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
                    Events.update event_id,
                        $addToSet: tags: tag
                    $('#add_event_tag').val('')

    'click .event_tag': (e,t)->
        event =Events.findOne FlowRouter.getParam('event_id')
        tag = @valueOf()
        if tag is event.type
            Events.update FlowRouter.getParam('event_id'),
                $set: type: ''
        Events.update FlowRouter.getParam('event_id'),
            $pull: tags: tag
        $('#add_event_tag').val(tag)


    'click .type_button': (e,t)->
        current_type = @type
        type = e.currentTarget.innerHTML.trim().toLowerCase()
        Events.update FlowRouter.getParam('event_id'),
            $pull: tags: current_type
        Events.update FlowRouter.getParam('event_id'),
            $set: type: type
            $addToSet: tags: type

    'click #save_event': ->
        description = $('#description').val()
        Docs.update FlowRouter.getParam('event_id'),
            $set:
                description: description
                # tagCount: @tags.length
        FlowRouter.go '/Events'
        selected_event_tags.clear()
        for tag in tags
            selected_event_tags.push tag



    'blur #title': ->
        title = $('#title').val()
        if title.length is 0
            Bert.alert 'Must include title', 'danger', 'growl-top-right'
        else
            Events.update FlowRouter.getParam('event_id'),
                $set: title: title

Template.edit_event.onRendered ->
    $('#datetimepicker').datetimepicker()
    