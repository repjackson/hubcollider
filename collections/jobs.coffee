Jobs = new (Mongo.Collection)('jobs')
Meteor.methods
    'jobs.post': (title, location, schedule, description, responsibilities, qualifications) ->
        # Verify that user is logged in
        if !Meteor.user()
            throw new (Meteor.Error)(401, 'You need to be signed in to continue')
        # Verify that required fields are empty
        if !title
            throw new (Meteor.Error)(422, 'Job title should not be blank')
        if !location
            throw new (Meteor.Error)(422, 'Job location should not be blank')
        if !description
            throw new (Meteor.Error)(422, 'Job description should not be blank')
        # Create job object to be inserted into DB
        job =
            title: title
            location: location
            schedule: schedule
            description: description
            responsibilities: responsibilities
            qualifications: qualifications
            author: Meteor.userId()
            createdOn: new Date
        # Insert new job
        Jobs.insert job

    'jobs.remove': (jobId) ->
        # Verify that user is logged in
        if !Meteor.user()
            throw new (Meteor.Error)(401, 'You need to be signed in to continue')
        # Verify that job exists
        if Jobs.find(_id: jobId).count() == 0
            throw new (Meteor.Error)(111, 'Not a valid job')
        # Remove job by jobId
        Jobs.remove _id: jobId

    'jobs.update': (jobId, title, location, schedule, description, responsibilities, qualifications) ->
        # Verify that user is logged in
        if !Meteor.user()
            throw new (Meteor.Error)(401, 'You need to be signed in to continue')
        # Verify that job exists
        if Jobs.find(_id: jobId).count() == 0
            throw new (Meteor.Error)(111, 'Not a valid job')
        # Update job by jobId
        Jobs.update { _id: jobId }, $set:
            title: title
            location: location
            schedule: schedule
            description: description
            responsibilities: responsibilities
            qualifications: qualifications