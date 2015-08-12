codeforcesAllView = require './codeforces-all-view'

module.exports =
class codeforcesAll
  constructor: (@title) ->

  getTitle:     -> @title
  getViewClass: -> codeforcesAllView
