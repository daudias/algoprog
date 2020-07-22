mongoose = require('mongoose')

import Table from './table'
import logger from '../log'

problemsSchema = new mongoose.Schema
    _id: String
    name: String
    tables: [String]
    level: String
    testSystemData: mongoose.Schema.Types.Mixed

problemsSchema.methods.upsert = () ->
    # https://jira.mongodb.org/browse/SERVER-14322
    try
        @update(this, {upsert: true})
    catch
        logger.info "Could not upsert a problemsSchema"

problemsSchema.statics.findByLevel = (level) ->
    return Problem.find
        level: level

problemsSchema.statics.findByIds = (ids) ->
    return Problem.find
        _id: {$in : ids}

Problem = mongoose.model('Problems', problemsSchema);

export default Problem
