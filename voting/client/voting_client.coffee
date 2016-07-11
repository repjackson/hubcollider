Template.voting.helpers
    points: -> Template.parentData(0).points
    
    vote_up_button_class: -> if Meteor.userId() is @authorId or not Meteor.userId() then 'disabled' else ''

    vote_up_icon_class: -> if Meteor.userId() and @up_voters and Meteor.userId() in @up_voters then '' else 'outline'

    vote_down_button_class: -> if Meteor.userId() is @authorId or not Meteor.userId() then 'disabled' else ''

    vote_down_icon_class: -> if Meteor.userId() and @down_voters and Meteor.userId() in @down_voters then '' else 'outline'

    
    
Template.voting.events
    'click .vote_up': -> Meteor.call 'vote_up', @_id

    'click .vote_down': -> Meteor.call 'vote_down', @_id
