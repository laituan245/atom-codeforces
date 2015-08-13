{$$, View} = require 'atom-space-pen-views'
cheerio = require 'cheerio'
request = require 'request'
shell = require 'shell'
module.exports =
  (contestId, index, problemName) =>
    class CodeforceSingleView extends View

      contestId: contestId
      index: index
      problemName: problemName

      @content: ->
        @div class:"codeforces-single", charset: "UTF-8",  =>
          @div class: "problem_header", outlet: "problem_header", =>
            @div =>
              @h2 style:"display: inline-block; margin-right: 12px;", contestId + index + ". " + problemName
              @button class:"btn-info disabled", id:"submit_btn/" + contestId + "/" + index, style:"font-size:14px;" ,"Submit"
            @p class: "general_info", outlet: "general_info"
          @div class:"problem_detail", outlet: "problem_detail", "Loading ..."

      initialize: ({@uri}) ->
        @populateViews()

      populateViews: ->
        onThisProblemDataReceived = (error, response, body) =>
          $ = cheerio.load(body)

          GeneralInfoHTML = $('.time-limit').text().replace("time limit per test", "Time limit per test: ");
          GeneralInfoHTML = GeneralInfoHTML + "<br>" + $('.memory-limit').text().replace("memory limit per test", "Memory limit per test: ");
          GeneralInfoHTML = GeneralInfoHTML + "<br>" + $('.input-file').text().replace("input", "Input: ");
          GeneralInfoHTML = GeneralInfoHTML + "<br>" + $('.output-file').text().replace("output", "Output: ");

          $('.title', '.header').remove()
          $('.time-limit').remove()
          $('.memory-limit').remove()
          $('.input-file').remove()
          $('.output-file').remove()
          tempHTML =  $('div.problem-statement').html()
          if tempHTML
            while (tempHTML != tempHTML.replace("&#x2009;", " "))
              tempHTML = tempHTML.replace("&#x2009;", " ")
            @problem_detail.html tempHTML
            @general_info.html GeneralInfoHTML
            tempElement = document.getElementById("submit_btn/" + contestId + "/" + index)
            if tempElement
              tempElement.className = "btn-info"
              tempElement.onclick = @onSubmitButtonClicked
          else
            @problem_detail.html "<i>Something is wrong. Please try again later.</i>"
        request 'http://codeforces.com/problemset/problem/' + contestId + '/' + index, onThisProblemDataReceived

      onSubmitButtonClicked: ->
        shell.openExternal("http://codeforces.com/problemset/problem/" + contestId + "/" + index)
