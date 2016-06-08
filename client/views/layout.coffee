Template.body.events
    'click #leftMenu': (e) ->
        $('#leftSidebarMenu.ui.sidebar').sidebar(dimPage: false).sidebar 'toggle'

Template.body.events
    'click #rightMenu': (e) ->
        $('#rightSidebarMenu.ui.sidebar').sidebar(dimPage: false).sidebar 'toggle'

    'click .select_bookmark': ->
        console.log @