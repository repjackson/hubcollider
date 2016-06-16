@setTitle = (title) ->
    base = 'Collider'
    if title
        document.title = title + ' - ' + base


# Meteor.startup ->
#     GoogleMaps.load
#         key: 'AIzaSyBluAacaAcSdXuk0hTRrnvoly0HI5wcf2Q'
#         libraries: 'places'