@selected_tags = new ReactiveArray []

Template.cloud.onCreated ->
    @autorun -> Meteor.subscribe('people_tags', selected_tags.array())

Template.cloud.helpers
    globaltags: ->
        # userCount = Meteor.users.find().count()
        # if 0 < userCount < 3 then tags.find { count: $lt: userCount } else tags.find()
        Peopletags.find()
#
    # globaltagClass: ->
    #     buttonClass = switch
    #         when @index <= 20 then 'big'
    #         when @index <= 40 then 'large'
    #         when @index <= 60 then ''
    #         when @index <= 80 then 'small'
    #         when @index <= 100 then 'tiny'
    #     return buttonClass

    globaltagClass: ->
        buttonClass = switch
            when @index <= 10 then 'big'
            when @index <= 20 then 'large'
            when @index <= 30 then ''
            when @index <= 40 then 'small'
            when @index <= 50 then 'tiny'
        return buttonClass

    selected_tags: -> selected_tags.list()

    user: -> Meteor.user()



Template.cloud.events
    'click .selecttag': -> selected_tags.push @name
    'click .unselecttag': -> selected_tags.remove @valueOf()
    'click #cleartags': -> selected_tags.clear()