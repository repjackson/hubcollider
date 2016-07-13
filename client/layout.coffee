##jQuery to execute hide of Sidebar
Template.layout.onRendered ->
    # $('.ui.sidebar');

Template.body.events
    # 'click #menu': ->
    #     $('.ui.sidebar').sidebar('toggle')
    # 'click #home_link': ->
    #     $('.ui.sidebar').sidebar('setting', 'dimPage', false).sidebar('toggle')
    # 'click .side_menu_item': ->
    #     $('.ui.sidebar').sidebar('hide')
