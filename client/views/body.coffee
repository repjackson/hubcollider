Template.body.events
    'click #accelerator_link': ->
        FlowRouter.go '/'
        selected_tags.clear()
        selected_tags.push 'accelerator'

    'click #perks_link': ->
        selected_tags.clear()
        selected_tags.push 'perks'
        FlowRouter.go '/'

    'click #economy_link': ->
        selected_tags.clear()
        FlowRouter.go '/'
        selected_tags.push 'economy'

    'click #crowd_sourcing_link': ->
        selected_tags.clear()
        FlowRouter.go '/'
        selected_tags.push 'crowd sourcing'
