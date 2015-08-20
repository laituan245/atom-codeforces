{$$, View} = require 'atom-space-pen-views'

module.exports =
  class userStatisticsView extends View
    @content: ->
      @div class:"user-statistics", =>
        @h1 "This is a user statistics view"
