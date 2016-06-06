Template.updateProfile.onCreated ->
    @searchQuery = new ReactiveVar('')
    @limit = new ReactiveVar(20)
    @usersCount = new ReactiveVar(0)
    @autorun =>
        # Set subscriptions
        @subscribe 'users.all', @searchQuery.get(), @limit.get()
        @subscribe 'selftags'
        @usersCount.set Counts.get('users.all')
        # Get current user's social media accounts
        currentUser = Meteor.users.findOne(_id: Meteor.userId())
        # Display social media links
        if currentUser and currentUser.socialMedia
            $('#socialMediaAccounts').empty()
            for prop of currentUser.socialMedia
                smLink = '<a id="' + prop + '" class="smAccount" href="' + currentUser.socialMedia[prop] + '"><img src="/img/' + prop + '.svg"/></a>'
                $(smLink).appendTo '#socialMediaAccounts'

Template.updateProfile.onRendered ->
    $('input[type=submit]').addClass 'disabled'
    Session.set 'startingBio', $('[data-id=biography]').val()
    return

Template.updateProfile.events
    'keyup [data-id=biography], keyup [data-id=addSocialMedia]': (event, template) ->
        # If bio section has changed or social media section has text enable the submit button, else disable it
        if template.find('[data-id=biography]').value != Session.get('startingBio') or template.find('[data-id=addSocialMedia]').value.toString().trim() != ''
            $('input[type=submit]').removeClass 'disabled'
        else
            $('input[type=submit]').addClass 'disabled'
        return
    'submit [data-id=update-profile-form]': (event, template) ->
        event.preventDefault()
        # Only continue if button isn't disabled
        if !$('input[type=submit]').hasClass('disabled')
            user =
                biography: template.find('[data-id=biography]').value
                socialMedia: {}
            # Get current social media accounts for this user
            user.socialMedia = Meteor.users.findOne(_id: Meteor.userId()).socialMedia or {}
            bioChanged = false
            numSmAdded = 0
            numInvalidSm = 0
            if user.biography != Session.get('startingBio')
                bioChanged = true
            # Add social media accounts if any were entered
            newSocialMedia = template.find('[data-id=addSocialMedia]').value.toString().split(',')
            x = 0
            while x < newSocialMedia.length
                newSocialMedia[x] = newSocialMedia[x].trim()
                if newSocialMedia[x] != ''
                    if newSocialMedia[x].indexOf('http://') == -1 and newSocialMedia[x].indexOf('https://') == -1
                        newSocialMedia[x] = 'http://' + newSocialMedia[x]
                    if newSocialMedia[x].toLowerCase().indexOf('facebook') != -1
                        user.socialMedia.facebook = newSocialMedia[x]
                        numSmAdded++
                    else if newSocialMedia[x].toLowerCase().indexOf('twitter') != -1
                        user.socialMedia.twitter = newSocialMedia[x]
                        numSmAdded++
                    else if newSocialMedia[x].toLowerCase().indexOf('linkedin') != -1
                        user.socialMedia.linkedin = newSocialMedia[x]
                        numSmAdded++
                    else if newSocialMedia[x].toLowerCase().indexOf('instagram') != -1
                        user.socialMedia.instagram = newSocialMedia[x]
                        numSmAdded++
                    else if newSocialMedia[x].toLowerCase().indexOf('plus.google') != -1
                        user.socialMedia.googlePlus = newSocialMedia[x]
                        numSmAdded++
                    else if newSocialMedia[x].toLowerCase().indexOf('github') != -1
                        user.socialMedia.github = newSocialMedia[x]
                        numSmAdded++
                    else if newSocialMedia[x].toLowerCase().indexOf('youtube') != -1
                        user.socialMedia.youtube = newSocialMedia[x]
                        numSmAdded++
                    else
                        numInvalidSm++
                x++
            if bioChanged or numSmAdded > 0
                Meteor.call 'users.updateProfile', user, (error, result) ->
                    if error
                        Bert.alert error.reason, 'danger', 'growl-top-right'
                    else
                        if numInvalidSm > 0
                            Bert.alert 'Profile updated but some social media links were invalid', 'success', 'growl-top-right'
                        else
                            Bert.alert 'Profile successfully updated', 'success', 'growl-top-right'
                        template.find('[data-id=addSocialMedia]').value = ''
                    return
            else
                Bert.alert 'Invalid social media links', 'danger', 'growl-top-right'

    'keydown #add_self_tag': (e,t)->
        e.preventDefault
        tag = $('#add_self_tag').val().toLowerCase().trim()
        switch e.which
            when 13
                if tag.length > 0
                    Meteor.call 'add_self_tag', tag, ->
                        $('#add_self_tag').val('')

    'click .remove_self_tag': ->
        tag = @valueOf()
        Meteor.call 'remove_self_tag', tag, ->
            $('#add_self_tag').val(tag)

Template.updateProfile.helpers
    user: -> Meteor.user()

    people: -> Meteor.users.find()

    matchedUsersList:->
        users = Meteor.users.find({_id: $ne: Meteor.userId()}).fetch()
        userMatches = []
        for user in users
            tagIntersection = _.intersection(user.tags, Meteor.user().tags)
            userMatches.push
                matchedUser: user.username
                tagIntersection: tagIntersection
                length: tagIntersection.length
        sortedList = _.sortBy(userMatches, 'length').reverse()
        return sortedList

    selftags: -> Docs.findOne().tags