{$$, View, TextEditorView} = require 'atom-space-pen-views'
userStatistics = require './user/user-statistics.coffee'
cheerio = require 'cheerio'
request = require 'request'

module.exports =
  class codeforcesStatisticsView extends View
    @content: ->
      @div class:'codeforces-statistics', =>
        @h1 "Codeforces Statistics Tool"
        @div class: 'search-container', =>
          @div class: 'editor-container', =>
            @subview 'searchEditorView', new TextEditorView(mini: true)
          @div class: 'btn-group', =>
            @button id:'searchButton', outlet: 'searchButton', class: 'btn btn-success', 'Search'
          @form style:'font-size:17px;', =>
            @div class:'inline-block', style:'margin-right:10px; padding:10px;',=>
              @input type:'radio', outlet: 'userRadioButton', checked:'checked'
              @span ' Users'
            @div class:'inline-block', style:'padding:10px;', =>
              @input type:'radio', outlet: 'contestRadioButton'
              @span ' Contests'
        @div class: 'main', =>
          @div class: 'rating_table', outlet: 'rating_table', =>
            @h2 outlet: 'top100Heading', class: 'section-heading icon icon-star','Top 100 users'
            @span class: 'loading-text-span', outlet: 'loading_text', "Loading ..."
            @ul class: 'list-group', outlet: 'list'

    @searchType = 'user'

    initialize: ({@uri}) ->
      @searchEditorView.getModel().setPlaceholderText('Enter a user handle')
      @showRatingTable()

      @userRadioButton.on 'click', =>
        @setSearchType('user')
      @contestRadioButton.on 'click',=>
        @setSearchType('contest')

    performSearch: ->

    setSearchType: (searchType) ->
      if searchType is 'user'
        @searchType = 'users'
        @userRadioButton.prop('checked', true)
        @contestRadioButton.prop('checked', false)
        @searchEditorView.getModel().setPlaceholderText('Enter a user handle')
        @rating_table.removeClass('hidden')
      else if searchType is 'contest'
        @searchType = 'contests'
        @userRadioButton.prop('checked', false)
        @contestRadioButton.prop('checked', true)
        @searchEditorView.getModel().setPlaceholderText('Enter a contest id')
        @rating_table.addClass('hidden')

    onClickUserHandle: (userHandle) =>
      =>
        currentlyOpened = false
        for panelItem in atom.workspace.getPaneItems()
          if panelItem.title in ["User " + userHandle]
            currentlyOpened = true
            atom.workspace.getActivePane().activateItem panelItem
            break
        if not currentlyOpened
          atom.workspace.getActivePane().activateItem new userStatistics ("User " + userHandle)

    showRatingTable: ->
      onRatingTableReceived = (error, response, body) =>
        $ = cheerio.load(body)
        $('div.lt').remove(); $('div.rt').remove(); $('div.lb').remove();
        $('div.rb').remove(); $('th', 'tr').remove();
        @loading_text.addClass "hidden"
        userCount = 0
        @list.append $$ ->
          @li class: 'list-item', style:"border-top-style: solid;", =>
            @div class: 'inline-block', style: "width:12%;", "Rank"
            @div class: 'inline-block', style: "width:46%", "User handle"
            @div class: 'inline-block', style: "width:30%", "# of contests"
            @div class: 'inline-block', style: "width:12%;", "Rating"

        for row in $('tr','div.datatable.ratingsDatatable')
          if $($('td',row)[1]).html()
            $($('a',row)).attr("href", "#")
            userCount += 1
            curUserHandle = $($('td',row)[1]).text().trim()
            $('a', $('td',row)[1]).attr("id", "a_user_nb_" + userCount)
            @list.append $$ ->
              @li class: 'list-item', =>
                @div class: 'inline-block', style: "width:12%;", =>
                  @span $($('td',row)[0]).text()
                @div class: 'inline-block', style: "width:46%", id: 'user_nb_' + userCount
                @div class: 'inline-block', style: "width:30%", =>
                  @span $($('td',row)[2]).text()
                @div class: 'inline-block', style: "width:12%;", =>
                  @span $($('td',row)[3]).text()
            document.getElementById('user_nb_' + userCount).innerHTML = $($('td',row)[1]).html()
            document.getElementById('a_user_nb_' + userCount).onclick = @onClickUserHandle(curUserHandle)
            if userCount == 100
              break


      request 'http://codeforces.com/ratings', onRatingTableReceived
