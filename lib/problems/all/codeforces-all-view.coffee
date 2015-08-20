request = require 'request'
{$$, View} = require 'atom-space-pen-views'
CategoryPanelView = require './category-panel-view'

module.exports =
class codeforcesAllView extends View

  @content: ->
   @div class: 'codeforces-all', =>
     @div class:"contest_notice", =>
        @div outlet: 'contest_list', class:"disabled"
        @span outlet: 'contest_notice_span', "Loading ..."
     @div class: 'panels-row', =>
       @subview 'ImplementationCategoryPanel', new CategoryPanelView('Implementation')
       @subview 'BruteForceCategoryPanel', new CategoryPanelView("Brute Force")
       @subview 'GreedyCategoryPanel', new CategoryPanelView('Greedy')

     @div class: 'panels-row', =>
       @subview 'DpCategoryPanel', new CategoryPanelView('Dynamic Programming')
       @subview 'GraphCategoryPanel', new CategoryPanelView('Graph')
       @subview 'MathandGeometryCategoryPanel', new CategoryPanelView('Math and Geometry')

  initialize: ({@uri}) ->
    @populateViews()

  populateViews: ->
    @updateContestNotice()
    @refreshIntervalId = setInterval(@updateContestNotice, 40000)
    @showImplementationProblems()
    @showBruteForceProblems()
    @showGreedyProblems()
    @showDPproblems()
    @showGraphProblems()
    @showMathandGeometryProblems()

  getTimeString: (seconds) ->
    if seconds < 0
      return "Starting soon"
    days = parseInt(seconds / (24 * 3600))
    seconds = seconds % (24 * 3600);
    hours = parseInt (seconds / 3600)
    seconds = seconds % 3600
    minutes = parseInt (seconds / 60)
    if days < 1 and hours < 1 and minutes < 1
      return "Starting soon"
    rsStr = ""
    if days > 1
      rsStr = rsStr + days + " days   "
    if days == 1
      rsStr = rsStr + days + " day   "
    if hours > 1
      rsStr = rsStr + hours + " hours   "
    if hours == 1
      rsStr = rsStr + hours + " hour   "
    if days == 0
      if minutes > 1
        rsStr = rsStr + minutes + " minutes"
      if minutes == 1
        rsStr = rsStr + minutes + " minute"
    return rsStr

  updateContestNotice: =>
    currentlyOpened = false
    for panelItem in atom.workspace.getPaneItems()
      if panelItem.title in ["Codeforces"]
        currentlyOpened = true
        break
    if not currentlyOpened
      clearInterval(@refreshIntervalId)

    onContestDataReceived = (error, response, body) =>
      if (!error && response.statusCode == 200)
        @contest_list.empty()
        contests = JSON.parse(body).result
        upcomingContests = []
        hasUpcomingContest = false
        for contest in contests
          if contest.phase in ["BEFORE"]
            upcomingContests.push(contest)
            hasUpcomingContest = true

        if not hasUpcomingContest
          @contest_list.addClass "disabled"
          @contest_notice_span.removeClass "hidden"
          @contest_notice_span.text ("There is currently no upcoming contest")
        else
          @contest_notice_span.addClass "hidden"
          @contest_list.removeClass "disabled"

          maxStrLength = 0
          for contest in upcomingContests
            remainingTime = -contest.relativeTimeSeconds
            remainingTime = remainingTime - 300  # The registration closes 5 minutes before the actual contest
            timeStr = @getTimeString remainingTime
            if contest.name.length > maxStrLength
              maxStrLength = contest.name.length
            @contest_list.append $$ ->
              @li style:"width: 410px; text-align: left; margin: 0 auto; padding-bottom: 4px;", =>
                  @span style:"margin-right: 10px;", contest.name
                  @span class: "small highlight-success", timeStr
          if maxStrLength > 50
            @contest_list.children().css("width", "550px")

      else
        request response.request.href, onContestDataReceived

    request ' http://codeforces.com/api/contest.list?gym=false', onContestDataReceived

  onProblemDataReceived = (panel) ->
    (error, response, body) ->
      if (!error && response.statusCode == 200)
        panel.addProblems(JSON.parse(body).result.problems)
      else
        request response.request.href, onProblemDataReceived(panel)


  showImplementationProblems: ->
    request 'http://codeforces.com/api/problemset.problems?tags=implementation', onProblemDataReceived(@ImplementationCategoryPanel)

  showBruteForceProblems: ->
    request 'http://codeforces.com/api/problemset.problems?tags=brute%20force', onProblemDataReceived(@BruteForceCategoryPanel)

  showGreedyProblems: ->
    request 'http://codeforces.com/api/problemset.problems?tags=greedy', onProblemDataReceived(@GreedyCategoryPanel)

  showDPproblems: ->
    request 'http://codeforces.com/api/problemset.problems?tags=dp', onProblemDataReceived(@DpCategoryPanel)

  showGraphProblems: ->
    request 'http://codeforces.com/api/problemset.problems?tags=graphs&dfs%20and%20similar&shortest%20paths%22', onProblemDataReceived(@GraphCategoryPanel)

  showMathandGeometryProblems: ->
    request 'http://codeforces.com/api/problemset.problems?tags=math&geometry', onProblemDataReceived(@MathandGeometryCategoryPanel)
