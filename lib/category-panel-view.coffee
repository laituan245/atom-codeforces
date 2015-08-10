{$$, View} = require 'atom-space-pen-views'

module.exports =
class CategoryPanelView extends View

  count: 0
  problemsPerPanel: 6
  curPageNb: 1
  maxPageNb: 245

  @content: (title) ->
    @div class: 'padded category-panel', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', outlet: 'heading', title
        @div class: 'panel-body padded', =>
          @span class: 'loading-text-span', outlet: 'loading_text', "Loading ..."
          @ul class: 'list-group', outlet: 'list'
          @div class: 'panel_bottom', =>
            @button class:'hidden', outlet:'prev_btn', id: 'prev_btn', "Prev"
            @span  class:'hidden', outlet:'page_nb_span' ,id: 'page_nb_span', "Page 1"
            @button  class:'hidden', outlet:'next_btn', id: 'next_btn', "Next"

  updateListGroup: =>
    @list.empty()
    tempCount  = 0
    for problem in @myProblems
      if (tempCount >= (@curPageNb-1) * @problemsPerPanel and tempCount < @curPageNb * @problemsPerPanel)
        @addProblem(problem)
      tempCount += 1

  updatePanelBottom: =>
    @prev_btn.addClass "disabled" if @curPageNb is 1
    @prev_btn.removeClass "disabled" if not (@curPageNb is 1)
    @next_btn.addClass "disabled" if @curPageNb is @maxPageNb
    @next_btn.removeClass "disabled" if not (@curPageNb is @maxPageNb)
    @page_nb_span.text ("Page " + @curPageNb)

  onNextButtonClicked: =>
    @curPageNb = @curPageNb + 1
    @updatePanelBottom()
    @updateListGroup()

  onPrevButtonClicked: =>
    @curPageNb = @curPageNb - 1
    @updatePanelBottom()
    @updateListGroup()

  addProblems: (problems) ->

    @myProblems = problems
    @prev_btn.removeClass "hidden"
    @prev_btn.addClass "disabled"
    @prev_btn.on "click", @onPrevButtonClicked

    @next_btn.removeClass "hidden"
    @next_btn.on "click", @onNextButtonClicked

    @page_nb_span.removeClass "hidden"
    @loading_text.addClass "hidden"

    for problem in problems
      @count = @count + 1
      if (@count <= @problemsPerPanel)
        @addProblem(problem)

    @maxPageNb = parseInt (@count / @problemsPerPanel)
    if (@count % @problemsPerPanel > 0)
      @maxPageNb += 1

  addProblem: (problem) ->
    @list.append $$ ->
      @li class: 'list-item', =>
          @span class: 'inline-block ', problem.contestId + problem.index + ". " + " " + problem.name
