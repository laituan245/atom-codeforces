request = require 'request'
{View} = require 'atom-space-pen-views'
CategoryPanelView = require './category-panel-view'

module.exports =
class codeforcesView extends View

  @content: ->
   @div class: 'codeforces', =>
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
    @showImplementationProblems()
    @showBruteForceProblems()
    @showGreedyProblems()
    @showDPproblems()
    @showGraphProblems()
    @showMathandGeometryProblems()

  onProblemDataReceived = (panel) ->
    (error, response, body) ->
      if (!error && response.statusCode == 200)
        panel.addProblems(JSON.parse(body).result.problems)

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
