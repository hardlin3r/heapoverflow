# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
wrapWithList = (element) ->
  "<li class=list-group-item>#{element}</li>"
$ ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();
  $('.answers').on('ajax:success', (event, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('#answer-' + answer.id + ' .vote ul').html(JST['templates/vote_answer']({ answer: answer})))
  $('#question').on('ajax:success', (event, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    $('#question .vote_question ul').html(JST['templates/vote_question']({ question: question})))
###
$(document).ready(ready);
$(document).on('page:load', ready);
$(document).on('page:update', ready);
###
