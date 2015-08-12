CodeforceSingleView = require './codeforces-single-view'

module.exports =
class codeforceSingle
  constructor: (@contestId, @index, @problemName) ->

  getContestId: -> @contestId
  getIndex:     -> @index
  getProblemName: -> @problemName
  getTitle:     -> @contestId + @index + ". " + @problemName
  getViewClass: -> CodeforceSingleView @getContestId(), @getIndex(), @getProblemName()
