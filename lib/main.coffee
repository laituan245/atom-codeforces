codeforcesAll = require './problems/all/codeforces-all'
codeforcesStatistics = require './statistics/codeforces-statistics'
SubAtom = require 'sub-atom'

module.exports =
  allProblemViewTitle: "CF Problems"
  statisticsViewTitle: "CF Statistics"

  activate: ->
    @subs = new SubAtom

    # Add a command for loading Codeforces problems
    @subs.add atom.commands.add 'atom-workspace', 'codeforces-problem:open': =>
      currentlyOpened = false
      for panelItem in atom.workspace.getPaneItems()
        if panelItem.title in [@allProblemViewTitle]
          currentlyOpened = true
          atom.workspace.getActivePane().activateItem panelItem
          break
      if not currentlyOpened
        atom.workspace.getActivePane().activateItem new codeforcesAll @allProblemViewTitle


    # Add a command for loading statistics
    @subs.add atom.commands.add 'atom-workspace', 'codeforces-statistics:open': =>
      currentlyOpened = false
      for panelItem in atom.workspace.getPaneItems()
        if panelItem.title in [@statisticsViewTitle]
          currentlyOpened = true
          atom.workspace.getActivePane().activateItem panelItem
          break
      if not currentlyOpened
        atom.workspace.getActivePane().activateItem new codeforcesStatistics @statisticsViewTitle

  deactivate: ->
    @subs.dispose()
