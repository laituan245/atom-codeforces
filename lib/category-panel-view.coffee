{$$, View} = require 'atom-space-pen-views'

module.exports =
class CategoryPanelView extends View

  count: 0

  @content: (title) ->
    @div class: 'padded category-panel', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', title
        @div class: 'panel-body padded', =>
          @ul class: 'list-group', outlet: 'list'

  addProblems: (problems) ->
    for problem in problems
      @count = @count + 1
      if @count < 6
        @addProblem(problem)


  addProblem: (problem) ->
    @list.append $$ ->
      @li class: 'list-item', =>
        @span class: 'inline-block', problem.name
