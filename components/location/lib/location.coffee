Meteor.methods
    updatelocation: (docid, result)->
        addresstags = (component.long_name for component in result.address_components)
        lowered_address_ags = _.map(addresstags, (tag)->
            tag.toLowerCase()
            )

        #console.log addresstags

        doc = Docs.findOne docid
        tags_without_address = _.difference(doc.tags, doc.addresstags)
        tags_with_new = _.union(tags_without_address, lowered_address_ags)

        Docs.update docid,
            $set:
                tags: tags_with_new
                locationob: result
                addresstags: lowered_address_ags
