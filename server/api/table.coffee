connectEnsureLogin = require('connect-ensure-login')

import logger from '../log'

import User from '../models/user'
import Result from '../models/result'
import Problem from '../models/problem'
import Table from '../models/table'

import addTotal from '../../client/lib/addTotal'

getTables = (table) ->
    tableIds = table.split(",")
    if tableIds.length != 1
        return tableIds
    table = await Table.findById(tableIds[0])
    return table.tables

getResult = (userId, tableId, collection) ->
    table = await collection.findById(tableId)
    result = await Result.findByUserAndTable(userId, tableId)
    result = result.toObject()
    result.problemName = table.name
    return result  

needUser = (userId, tables) ->
    for tableId in tables
        result = await Result.findByUserAndTable(userId, tableId)
        if result.solved > 0 or result.ok > 0 or result.attempts > 0
            return true
    return false

getUserResult = (user, tables) ->
    if not await needUser(user._id, tables)
        return null
    total = null
    results = []
    for tableId in tables
        table = await Table.findById(tableId)
        tableResults = []
        for subtableId in table.tables
            subtable = await Table.findById(subtableId)
            subtableResults = []
            for sstableId in subtable.tables
                subtableResults.push(getResult(user._id, sstableId, Table))
            for sstableId in subtable.problems
                subtableResults.push(getResult(user._id, sstableId, Problem))
            subtableResults = await Promise.all(subtableResults)
            for r in subtableResults
                total = addTotal(total, r)
            tableResults.push
                _id: subtableId
                name: subtable.name
                results: subtableResults
        results.push
            _id: tableId,
            tables: tableResults
    return 
        user: user
        results: results
        total: total
                

export default table = (userList, table) ->
    data = []
    users = User.findByList(userList)
    tables = getTables(table)
    [users, tables] = await Promise.all([users, tables])
    for user in users
        data.push(getUserResult(user, tables))
    results = await Promise.all(data)
    results = (r for r in results when r)
    results = results.sort (a, b) ->
        if a.user.active != b.user.active
            return if a.user.active then -1 else 1
        if a.total.solved != b.total.solved
            return b.total.solved - a.total.solved 
        if a.total.attempts != b.total.attempts
            return a.total.attempts - b.total.attempts
        return 0
    return results
