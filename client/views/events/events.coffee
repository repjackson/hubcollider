@selected_event_tags = new ReactiveArray []

Template.events.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'docs', selected_event_tags.array(), 'event'
    

Template.events.helpers
    events: -> Docs.find()



Template.events.events
    'click #add_event': ->
        Meteor.call 'add_event', (err, id)->
            if err then console.error err
            else FlowRouter.go "/events/edit/#{id}"


Template.view_event.helpers
    is_author: -> Meteor.userId() and Meteor.userId() is @authorId 

Template.view_event.events
    'click .edit_event': -> FlowRouter.go "/events/edit/#{@_id}"
    
    
    
    
    
# old event code
# Template.event.onRendered ->
#     data = Template.currentData()

#     Meteor.setTimeout (->
#        $('#datetimepicker').datetimepicker(
#             onChangeDateTime: (dp,$input)->
#                 val = $input.val()

#                 # console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
#                 minute = moment(val).minute()
#                 hour = moment(val).format('h')
#                 date = moment(val).format('Do')
#                 ampm = moment(val).format('a')
#                 weekdaynum = moment(val).isoWeekday()
#                 weekday = moment().isoWeekday(weekdaynum).format('dddd')

#                 month = moment(val).format('MMMM')
#                 year = moment(val).format('YYYY')

#                 datearray = [hour, minute, ampm, weekday, month, date, year]
#                 datearray = _.map(datearray, (el)-> el.toString().toLowerCase())
#                 # datearray = _.each(datearray, (el)-> console.log(typeof el))


#                 event = Events.findOne data._id
#                 tagsWithoutDate = _.difference(event.tags, event.datearray)
#                 tagsWithNew = _.union(tagsWithoutDate, datearray)

#                 Events.update data._id,
#                     $set:
#                         tags: tagsWithNew
#                         datearray: datearray
#                         dateTime: val
#             )
#         ), 500
