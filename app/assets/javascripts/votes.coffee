$ ->
  $('.set-vote').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    css_votable_id = "#" + vote.type.toLowerCase() + "-vote-" + vote.votable_id

    $("#{css_votable_id} .cancel a").removeClass('disabled').html(vote.votes_sum)
    $("#{css_votable_id} .plus a").addClass('disabled')
    $("#{css_votable_id} .minus a").addClass('disabled')

  $('.cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    css_votable_id = "#" + vote.type.toLowerCase() + "-vote-" + vote.votable_id

    $("#{css_votable_id} .cancel a").addClass('disabled').html(vote.votes_sum)
    $("#{css_votable_id} .plus a").removeClass('disabled')
    $("#{css_votable_id} .minus a").removeClass('disabled')
