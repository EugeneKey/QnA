# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  PrivatePub.subscribe '/questions/index', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.list-questions').append('<li><a href="/questions/' + question.id + '">' + question.title + '</a></li>')