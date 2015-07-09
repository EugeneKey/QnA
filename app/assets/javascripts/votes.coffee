$ ->
  $('.set-vote').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    css_votable_id = "#" + vote.type.toLowerCase() + "-vote-" + vote.votable_id
    $(css_votable_id).find(".score").html(vote.votes_sum)
    $(css_votable_id).find(".minus").hide()
    $(css_votable_id).find(".plus").hide()
    $(css_votable_id).find(".cancel").show()

  $('.cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)
    css_votable_id = "#" + vote.type.toLowerCase() + "-vote-" + vote.votable_id
    $(css_votable_id).find(".score").html(vote.votes_sum)
    $(css_votable_id).find(".minus").show()
    $(css_votable_id).find(".plus").show()
    $(css_votable_id).find(".cancel").hide()
