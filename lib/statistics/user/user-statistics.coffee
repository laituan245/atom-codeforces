userStatisticsView = require './user-statistics-view'

module.exports =
class userStatistics
  constructor: (@userHandle) ->

  getTitle:     -> "User " + @userHandle
  getViewClass: -> userStatisticsView @userHandle
