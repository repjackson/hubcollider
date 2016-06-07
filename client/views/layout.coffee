Template.body.events
    'click #leftMenu': (e) ->
        $('#leftSidebarMenu.ui.sidebar')
                .sidebar({
                  dimPage: false
                  })
                .sidebar('toggle')
    'click #rightMenu': (e) ->
        $('#rightSidebarMenu.ui.sidebar')
                .sidebar({
                  dimPage: false
                  })
                .sidebar('toggle')

# getHeight = ->
#     windowHeight = $(window).height()
#     headerHeight = $('.main-header').outerHeight(true)
#     footerHeight = $('.footer').outerHeight(true)
#     return "#{windowHeight - headerHeight - footerHeight} px"

# Template.layout.onCreated ->
#     @minHeight = new ReactiveVar(0)

# Template.layout.onRendered ->
#     @minHeight.set getHeight()
#     $(window).resize ->
#         @minHeight.set getHeight()
