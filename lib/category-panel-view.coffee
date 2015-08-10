{$$, View} = require 'atom-space-pen-views'

module.exports =
class CategoryPanelView extends View

  count: 0

  @content: (title) ->
    @div class: 'padded category-panel', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', title
        @div class: 'panel-body padded', =>
          @span class: 'loading-text-span', outlet: 'loading_text', "Loading ..."
          @ul class: 'list-group', outlet: 'list'
          @div class: 'buttons', =>
            @button class: 'hidden', outlet:'prev_btn', id: 'prev_btn', "Prev"
            @button class: 'hidden', outlet:'next_btn', id: 'next_btn', "Next"

  addProblems: (problems) ->
    @prev_btn.removeClass "hidden"
    @next_btn.removeClass "hidden"
    @loading_text.addClass ("hidden")
    for problem in problems
      @count = @count + 1
      if (@count < 6)
        @addProblem(problem, "")
      else
        @addProblem(problem, "hidden")


  addProblem: (problem, extraClass) ->
    @list.append $$ ->
      @li class: 'list-item', =>
          @span class: 'inline-block ' + extraClass, problem.contestId + problem.index + ". " + " " + problem.name
