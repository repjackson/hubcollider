Template.location.onCreated ->
    @editing_datetime = new ReactiveVar false

Template.location.onRendered ->
    Meteor.setTimeout (->
        $('#datetimepicker').datetimepicker(
            onChangeDateTime: (dp,$input)->
                val = $input.val()

                # console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
                minute = moment(val).minute()
                hour = moment(val).format('h')
                date = moment(val).format('Do')
                ampm = moment(val).format('a')
                weekdaynum = moment(val).isoWeekday()
                weekday = moment().isoWeekday(weekdaynum).format('dddd')

                month = moment(val).format('MMMM')
                year = moment(val).format('YYYY')

                datearray = [hour, minute, ampm, weekday, month, date, year]
                datearray = _.map(datearray, (el)-> el.toString().toLowerCase())
                # datearray = _.each(datearray, (el)-> console.log(typeof el))

                docid = FlowRouter.getParam 'docId'

                doc = Docs.findOne docid
                tags_without_date = _.difference(doc.tags, doc.datearray)
                tagsWithNew = _.union(tags_without_date, datearray)

                Docs.update docid,
                    $set:
                        tags: tagsWithNew
                        datearray: datearray
                        dateTime: val
            )

        ), 500


Template.location.helpers
    editing_datetime: -> Template.instance().editing_datetime.get()
    datetime: -> Template.parentData(0).datetime

Template.location.events
    'click .edit_datetime': (e,t)->
        t.editing_datetime.set true


    'click .save_datetime': (e,t)->
        doc_id = Template.parentData(0)._id
        text = t.$('.text').val()
        # console.log Template.parentData(1)
        
        Meteor.call 'update_datetime', doc_id, text
        t.editing_datetime.set false