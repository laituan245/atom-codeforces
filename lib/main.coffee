codeforcesAll = require './problems/all/codeforces-all'
SubAtom = require 'sub-atom'

module.exports =
  activate: ->
    @subs = new SubAtom
    @subs.add atom.commands.add 'atom-workspace', 'codeforces-problem:open': ->
      atom.workspace.getActivePane().activateItem new codeforcesAll "Codeforces"

  deactivate: ->
    @subs.dispose()
