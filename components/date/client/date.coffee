Template.date.onCreated ->
    @editing_date = new ReactiveVar false

Template.date.onRendered ->
    Meteor.setTimeout (->
        $('#datepicker').datetimepicker(
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

                # date_array = [hour, minute, ampm, weekday, month, date, year]
                date_array = [ampm, weekday, month, date, year]
                date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
                # date_array = _.each(date_array, (el)-> console.log(typeof el))

                doc_id = FlowRouter.getParam 'doc_id'

                doc = Docs.findOne doc_id
                tags_without_date = _.difference(doc.tags, doc.date_array)
                tags_with_new = _.union(tags_without_date, date_array)

                Docs.update doc_id,
                    $set:
                        tags: tags_with_new
                        date_array: date_array
                        date: val
            )

        ), 500


Template.date.helpers
    editing_date: -> Template.instance().editing_date.get()
    date: -> Template.parentData(0).date

Template.date.events
    'click .edit_date': (e,t)->
        t.editing_date.set true


    'click .save_date': (e,t)->
        doc_id = Template.parentData(0)._id
        text = t.$('.text').val()
        # console.log Template.parentData(1)
        
        Meteor.call 'update_date', doc_id, text
        t.editing_date.set false
        
    'click .clear_date': ->
        tags_without_date = _.difference(@tags, @date_array)
        Docs.update FlowRouter.getParam('doc_id'),
            $set:
                tags: tags_without_date
                date_array: []
                date: null
        $('#datepicker').val('')

