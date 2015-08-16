codeforcesStatisticsView = require './codeforces-statistics-view'

module.exports =
class codeforcesStatistics
  constructor: (@title) ->

  getTitle:     -> @title
  getViewClass: -> codeforcesStatisticsView
