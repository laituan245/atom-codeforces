codeforces = require './codeforces'
SubAtom = require 'sub-atom'

module.exports =
  activate: ->
    @subs = new SubAtom
    @subs.add atom.commands.add 'atom-workspace', 'codeforces:open': ->
      atom.workspace.getActivePane().activateItem new codeforces "Codeforces"

  deactivate: ->
    @subs.dispose()
