# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.add-comment-link').click (e) ->
    e.preventDefault();
    commentableTypeId= $(this).data('commentableTypeId')
    $('form#add-comment-' + commentableTypeId).show()

  questionId = $('.answers').data('questionId')
  current_user = $("#user").data('user-id');
  PrivatePub.subscribe '/questions/'+ questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    commentableTypeId = comment.commentable_type.toLowerCase() + '-' + comment.commentable_id
    $('#comments-list-' + commentableTypeId).append('<li>' + comment.text + '</li>')
    if current_user == comment.user_id
      $('form#add-comment-' + commentableTypeId).find('.form-control').val('')
      $('form#add-comment-' + commentableTypeId).hide()
