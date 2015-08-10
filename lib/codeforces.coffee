codeforcesView = require './codeforces-view'

module.exports =
class codeforces
  constructor: (@title) ->

  getTitle:     -> @title
  getViewClass: -> codeforcesView
