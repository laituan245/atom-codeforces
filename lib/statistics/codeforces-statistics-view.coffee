{$$, View, TextEditorView} = require 'atom-space-pen-views'
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
            @button outlet: 'searchUserButton', class: 'btn btn-default selected', 'Users'
            @button outlet: 'searchContestButton', class: 'btn btn-default', 'Contests'
        @div class: 'rating_table', outlet: 'rating_table', =>
          @h2 outlet: 'top100Heading', class: 'section-heading icon icon-star','Top 100 users'
          @span class: 'loading-text-span', outlet: 'loading_text', "Loading ..."
          @ul class: 'list-group', outlet: 'list'

    initialize: ({@uri}) ->
      @searchEditorView.getModel().setPlaceholderText('Enter a user handle')
      @showRatingTable()

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
            userCount += 1
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
            if userCount == 100
              break


      request 'http://codeforces.com/ratings', onRatingTableReceived
