Template.like.helpers
    like_count: -> Template.parentData(0).like_count
    
    like_item_class: -> if Template.parentData(0).likers and Meteor.userId() in Template.parentData(0).likers then 'red' else 'outline'
    
Template.like.events
    'click .like_item': -> 
        # console.log Template.parentData(0)
        Meteor.call 'like', Template.parentData(0)
