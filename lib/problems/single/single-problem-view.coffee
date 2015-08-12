{$$, View} = require 'atom-space-pen-views'

module.exports =
class SingleProblemView extends View
  @content: (title)->
    @h1 "Hello there"
