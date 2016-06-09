Meteor.startup ->
    # Accounts.validateNewUser (user) ->
    #     if user.emails and user.emails[0].address.length != 0
    #         return true
    #     throw new (Meteor.Error)(403, 'E-Mail address should not be blank')

    Accounts.validateNewUser (user) ->
        if user.username and user.username.length >= 3
            return true
        throw new (Meteor.Error)(403, 'Username must have at least 3 characters')


    # if Docs.find().count() is 0
    #     Docs.insert
    #         title: 'title1'
    #         tags: ['apple', 'banana', 'fruit']
    #         img_url: 'http://test.com/img.png'
    #         price: 5


    # Fake.user
    #     fields: [
    #         'name'
    #         'username'
    #         'emails.address'
    #         'profile.name'
    #     ]


    # Factory.define 'user', Users,
    #     username: 'test-user'
    #     name: 'Test user'
    #     email: 'test@example.com'
    # numberOfUsers = 10

    # if Meteor.users.find().count() is 0
    #     _(numberOfUsers).times (n) ->
    #         Factory.create 'user'


    # Factory.define 'doc', Docs,
    #     title: -> Fake.sentence()
    #     price: -> _.random 1, 15
    #     body: -> Fake.paragraph([15])
    #     tags: -> Fake.fromArray(['banana', 'apple', 'strawberry', 'raspberry', 'pear'])



    # if Docs.find({}).count() is 0
    #     _(10).times (n) ->
    #         Factory.create 'doc'
