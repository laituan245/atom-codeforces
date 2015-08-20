userStatisticsView = require './user-statistics-view'

module.exports =
class userStatistics
  constructor: (@title) ->

  getTitle:     -> @title
  getViewClass: -> userStatisticsView
