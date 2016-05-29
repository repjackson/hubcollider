Template.profile.events 'click [data-id=load-more]': (event, template) ->
    template.limit.set template.limit.get() + 20
    return

Template.profile.helpers
    user: ->
        Meteor.users.findOne _id: FlowRouter.getParam('_id')
    posts: ->
        Posts.find {}, sort: createdAt: -1
    hasMorePosts: ->
        Template.instance().limit.get() <= Template.instance().userPostsCount.get()

Template.profile.onCreated ->
    @limit = new ReactiveVar(20)
    @userPostsCount = new ReactiveVar(0)
    @autorun =>
        @subscribe 'users.profile', FlowRouter.getParam('_id'), @limit.get()
        @userPostsCount.set Counts.get('users.profile')
        # Get current user's social media accounts
        profileUser = Meteor.users.findOne(_id: FlowRouter.getParam('_id'))
        # Display social media links
        if profileUser and profileUser.socialMedia
            $('#socialMediaAccounts').empty()
            for prop of profileUser.socialMedia
                smLink = '<a id="' + prop + '" class="smAccount" href="' + profileUser.socialMedia[prop] + '"><img src="/img/' + prop + '.svg"/></a>'
                $(smLink).appendTo '#socialMediaAccounts'