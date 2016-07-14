@setTitle = (title) ->
    base = 'Collider'
    if title
        document.title = title + ' - ' + base


# Meteor.startup ->
#     GoogleMaps.load
#         key: 'AIzaSyBluAacaAcSdXuk0hTRrnvoly0HI5wcf2Q'
#         libraries: 'places'

BlazeLayout.setRoot('body')

Meteor.startup ->
    Stripe.setPublishableKey Meteor.settings.StripeTestPublishableKey

    handler = StripeCheckout.configure(
        key: Meteor.settings.StripeTestPublishableKey
        token: (token) ->
    )