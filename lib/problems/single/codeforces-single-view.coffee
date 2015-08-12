{$$, View} = require 'atom-space-pen-views'
cheerio = require 'cheerio'
request = require 'request'
module.exports =
  (contestId, index, problemName) =>
    class CodeforceSingleView extends View

      contestId: contestId
      index: index
      problemName: problemName

      @content: ->
        @div class:"codeforces-single", charset: "UTF-8",  =>
          @h2 contestId + index + ". " + problemName
          @div class:"problem_detail", outlet: "problem_detail", "Loading ..."

      initialize: ({@uri}) ->
        @populateViews()

      populateViews: ->
        onThisProblemDataReceived = (error, response, body) =>
          $ = cheerio.load(body)
          $('.output-file').remove()
          $('.input-file').remove()
          $('.title').remove()
          $('.time-limit').remove()
          $('.memory-limit').remove()
          tempHTML =  $('div.problem-statement').html()
          while (tempHTML != tempHTML.replace("&#x2009;", " "))
            tempHTML = tempHTML.replace("&#x2009;", " ")
          @problem_detail.html tempHTML

        request 'http://codeforces.com/problemset/problem/' + contestId + '/' + index, onThisProblemDataReceived
