{$$, View} = require 'atom-space-pen-views'
cheerio = require 'cheerio'
request = require 'request'
d3 = require 'd3'

module.exports = (userHandle) ->
    class userStatisticsView extends View
      myUserHandle: userHandle
      @content: ->
        @div class:"user-statistics", =>
          @h2 outlet:"loading_text", "Loading ..."
          @div class:"basic_data hidden", outlet:"basic_data", =>
            @span outlet:"current_rank", style:"float:left;"
            @span outlet: "user_handle", style:"float:left; clear:left;"
            @div style:"font-size:15.5px; margin-top:10px; float:left; clear:left;", =>
              @img src:"http://st.codeforces.com/images/icons/rating-24x24.png"
              @span style:"margin-left: 5px;", "Contest rating: "
              @span outlet: "current_rating"
              @span outlet: "best_performance", style:"font-size:14.5px;"
            @div style:"font-size:15.5px; margin-top:10px; float:left; clear:left;", =>
              @img src:"http://st.codeforces.com/images/icons/star_blue_24.png"
              @span style: "margin-left: 5px;", "Contribution: "
              @span outlet: "current_contribution"
            @h2 style:"margin-top:40px; float:left; clear:left;", "Effectiveness"
            @div style:"font-size:15.5px; float:left; clear:left;", id: userHandle + "_effectiveness_chart_container", =>
              @h2 style:"margin-top:0px; font-size:15.5px;", outlet: "loading_text_2", "Loading ..."

      toTitleCase: (str) ->
        str.replace /\w\S*/g, (txt) ->
          txt[0].toUpperCase() + txt[1..txt.length - 1].toLowerCase()

      rankToColor: (rankStr) ->
        tempStr = rankStr.toLowerCase()
        if tempStr in ['international grandmaster', 'grandmaster']
          return 'red'
        if tempStr in ['international master', 'master']
          return 'orange'
        if tempStr in ['candidate master']
          return 'violet'
        if tempStr in ['expert']
          return 'blue'
        if tempStr in ['specialist', 'pupil']
          return 'green'
        return 'gray'

      initialize: ({@uri}) ->
        @populateViews()

      populateViews: ->
        @displayBasicInfos()
        @drawEffectivenessChart()

      drawEffectivenessChart: ->
        onSubmissionDataReceived = (error, response, body) =>
          if (!error && response.statusCode == 200)
            @loading_text_2.addClass("hidden")
            submissionData = JSON.parse(body).result
            totalNbSubmission = submissionData.length
            accepted = 0; compilationError = 0; runtimeError = 0;
            timeLimit = 0; wrongAns = 0; otherError = 0;
            for submission in submissionData
              switch submission.verdict
                when "OK" then accepted += 1
                when "COMPILATION_ERROR" then compilationError += 1
                when "RUNTIME_ERROR" then runtimeError += 1
                when "TIME_LIMIT_EXCEEDED" then timeLimit += 1
                when "WRONG_ANSWER" then wrongAns += 1
                else otherError += 1;

            # After getting the submission data, let's actually draw the pie chart
            width = 245; height = 245; radius = Math.min(width, height) / 2;
            color = d3.scale.category20b();
            dataset = [{label: 'ACC', count: accepted },
                       {label: 'WA' , count: wrongAns},
                       {label: 'TLE', count: timeLimit},
                       {label: 'CE' , count: compilationError},
                       {label: 'RE' , count: runtimeError},
                       {label: 'Others', count: otherError}
                      ]
            svg = d3.select('#' + userHandle+ '_effectiveness_chart_container')
                    .append('svg')
                    .attr('width', width)
                    .attr('height', height)
                    .append('g')
                    .attr('transform', 'translate(' + (width / 2) +  ',' + (height / 2) + ')')

            arc = d3.svg.arc().outerRadius(radius)
            pie = d3.layout.pie().value((d) -> d.count).sort(null)
            path = svg.selectAll('path').data(pie(dataset))
                      .enter()
                      .append('path')
                      .attr('id', (d,i) -> userHandle + "_" + d.data.label)
                      .attr('d', arc)
                      .attr('fill', (d, i) ->
                        switch d.data.label
                          when 'ACC' then 'green'
                          when 'WA'  then 'orange'
                          when 'TLE' then 'yellow'
                          when 'CE'  then 'red'
                          when 'RE'  then 'pink'
                          when 'Others' then 'gray'
                      )
                      .attr('text-anchor', "middle")
                      .text((d,i) => dataset[i].label)
                      .on('mouseover', (d) ->
                        nodeSelection = d3.select(this).style({opacity:'0.8'})
                        #nodeSelection.select("text").style({opacity:'1.0'})
                      )
                      .on('mouseout', (d) ->
                        nodeSelection = d3.select(this).style({opacity:'1.0'})
                        #nodeSelection.select("text").style({opacity:'0.8'})
                      )

          else
            request 'http://codeforces.com/api/user.status?handle=' + userHandle, onSubmissionDataReceived

        request 'http://codeforces.com/api/user.status?handle=' + userHandle, onSubmissionDataReceived


      displayBasicInfos: ->
        onTheUserDataReceived = (error, response, body) =>
          if (!error && response.statusCode == 200)
            @loading_text.addClass("hidden")
            @basic_data.removeClass("hidden")
            userData = JSON.parse(body).result[0]

            colorClass = "user-" + @rankToColor(userData.rank)
            @current_rank.html(@toTitleCase(userData.rank))
            @user_handle.html(userData.handle)
            @current_rating.html(userData.rating)
            @current_rank.addClass (colorClass)
            @user_handle.addClass(colorClass)
            @current_rating.addClass(colorClass)

            maxColorClass = "user-" + @rankToColor(userData.maxRank)
            tempHTML = " (max. <span class='" + maxColorClass + "'>" + userData.maxRank + ", " + userData.maxRating + "</span>)"
            @best_performance.html (tempHTML)

            curContribution = userData.contribution;
            if curContribution > 0
              @current_contribution.css("color", "green");
              @current_contribution.html ("+" + curContribution)
            if curContribution < 0
              @current_contribution.css("color", "red");
              @current_contribution.html ("-" + curContribution)
          else
            request 'http://codeforces.com/api/user.info?handles=' + userHandle, onTheUserDataReceived

        request 'http://codeforces.com/api/user.info?handles=' + userHandle, onTheUserDataReceived
