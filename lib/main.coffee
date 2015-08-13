codeforcesAll = require './problems/all/codeforces-all'
SubAtom = require 'sub-atom'

module.exports =
  activate: ->
    @subs = new SubAtom
    @subs.add atom.commands.add 'atom-workspace', 'codeforces-problem:open': ->
      currentlyOpened = false
      for panelItem in atom.workspace.getPaneItems()
        if panelItem.title in ["Codeforces"]
          currentlyOpened = true
          atom.workspace.getActivePane().activateItem panelItem
          break
      if not currentlyOpened
        atom.workspace.getActivePane().activateItem new codeforcesAll "Codeforces"

  deactivate: ->
    @subs.dispose()
