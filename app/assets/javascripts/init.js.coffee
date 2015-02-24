myLightboxChart = undefined
myFeatherBox = undefined
tagOptions = []

handleSuccess = (data, status, xhr) ->
  switch status.what
    when 'created'
      switch status.whatCreated
        when 'service'
          $('.insertionForm').after status.htmlOutput
        when 'leader'
          $('#service_leader_id').append status.htmlOutput
        when 'service_type'
          $('#service_service_type_id').append status.htmlOutput
        when 'song'
          $('#songList').tagit 'createTag', status.tag.id, status.tag.label
        when 'aka'
          new_aka_song_id = status.song_id
          $.ajax
            'url': '/akas/' + status.aka_id
            'success': (responseText) ->
              $('td[tag=' + new_aka_song_id + ']').last().parent('tr').after responseText
              $('td[tag=' + new_aka_song_id + ']').last().parent('tr').children('td[contenteditable=true]').on('focus', prepAjaxUpdate).on 'blur', doAjaxUpdate
              return
    when 'destroyed'
      switch status.whatDestroyed
        when 'aka'
          $('tr#' + status.aka_id).fadeOut 'slow', $('tr#' + status.aka_id).remove
  return

deleteAnchorClicked = (thingToDelete, id, dataToSend) ->
  #TODO: Are you freaking sure?!?
  $.ajax
    type: 'DELETE'
    url: '/' + thingToDelete + '/' + id
    data: dataToSend
    dataType: 'JSON'
    success: (data, status, xhr) ->
      handleSuccess 'meh', data
      return
  return

addnewAnchorClicked = (thingToAdd, dataToSend) ->
  jqxhr = $.ajax(
    'url': '/' + thingToAdd + '/new'
    'data': dataToSend).done((data) ->
    myFeatherBox = $.featherlight(data, afterOpen: ->
      $('form#frm_create').validate()
      $('#frm_create input[type!=hidden]')[0].focus()
      return
    )
    $('#frm_create input[type=submit]').on 'click', (e) ->
      myFeatherBox.close()
      return
    $('#song_ccli_number').on 'blur', (e) ->
      if $('#song_song_name').val() == ''
        ccli_loader $('#song_ccli_number').val()
      return
    return
  ).fail((e) ->
    console.log 'error creating addnew form'
    console.dir e
    return
  )
  return

songUsageAnchorClicked = ->
  jqxhr = $.post('/usages/data/10').done((data) ->
    myFeatherBox = $.featherlight('<div class=\'breakdown_header\'>Usage Summary</div><div id=\'feather\'>' + data + '</div>')
    return
  ).fail((e) ->
    console.log 'error'
    console.dir e
    return
  )
  return

songAnchorClicked = (song_id) ->
  jqxhr = $.post('/songs/data/' + song_id).done((data) ->
    try
      myLightboxChart.destroy()
    catch e
      console.log 'something\'s gone wrong with the chart stuff: '
      console.log e
    mc = $('<canvas height=250>')
    ctx = mc.get(0).getContext('2d')
    myLightboxChart = new Chart(ctx).Doughnut(data.chart_data, animationSteps: 60)
    tabledata = ''
    for key of data.song_details
      tabledata += '<tr><td class=\'tdkey\'>' + key + '</td><td class=\'tddata\'>' + data.song_details[key] + '</td></tr>' if data.song_details.hasOwnProperty key
    $.featherlight.close()
    $.featherlight '<div class=\'breakdown_header\'>' + data.song_name + ' (' + data.tally + ')</div>' + '<div id=\'feathersac\' style=\'text-align:center; margin: 10px\'></div>' + '<div><table class=\'table table-condensed table-striped\'>' + tabledata + '</table></div>'
    $('#feathersac').html $(mc)
    return
  ).fail((e) ->
    console.log 'error'
    console.dir e
    return
  )
  return

leaderAnchorClicked = (el) ->
  leader_name = $(el).html()
  jqxhr = $.post('/leaders/data/' + el).done((data) ->
    arrlabel = []
    arrdata1 = []
    for d of data.chart_data
      if data.chart_data.hasOwnProperty d
        arrlabel.push d
        arrdata1.push data.chart_data[d]
    completedata = 
      'labels': arrlabel
      'datasets': [ {
        fillColor: 'rgba(151,187,205,0.5)'
        strokeColor: 'rgba(151,187,205,0.8)'
        highlightFill: 'rgba(151,187,205,0.75)'
        highlightStroke: 'rgba(151,187,205,1)'
        data: arrdata1
      } ]
    try
      myLightboxChart.destroy()
    catch e
      console.log 'something\'s gone wrong with the chart stuff: '
      console.log e
    mc = $('<canvas width=600 height=300>')
    ctx = mc.get(0).getContext('2d')
    myLightboxChart = new Chart(ctx).Bar(completedata)
    $.featherlight '<div class=\'breakdown_header\'>' + data.leader_name + '</div><div id=\'feather\'></div>'
    $('#feather').html $(mc)
    $('#feather').append data.usage_table
    #$.featherlight("<div>" + data + "</div>");
    return
  ).fail((e) ->
    console.log 'error'
    console.dir e
    return
  )
  return

$(document).on 'ready page:load', ->
  $(document).on('ajax:success', handleSuccess).on 'ajax:error', (xhr, status, error) ->
    console.log error
    alert 'failed'
    return
  elem = document.createElement('input')
  elem.setAttribute 'type', 'date'
  if elem.type == 'text'
    $('#service_date').datepicker dateFormat: 'yy-mm-dd'
  $('#songList').tagit
    tagSource: (search, showChoices) ->
      $.ajax
        url: '/songs/list'
        type: 'POST'
        data: search
        success: (choices) ->
          tagOptions = choices
          showChoices choices
          return
        error: (e) ->
          console.log 'something\'s wrong with fetching sons'
          console.log e
          return
      return
    allowSpaces: true
    allowNewTags: false
    onlyAvailableTags: true
    removeConfirmation: true
    onSubmit: ->
      $('#songList').tagit 'removeAll'
      return
    onTagClicked: (evt, ui) ->
      songAnchorClicked ui.tagLabel
      return
    showAutocompleteOnFocus: false
    beforeTagAdded: (event, ui) ->
      $.isNumeric ui.tag[0].children[2].defaultValue
    fieldName: 'service[songs][]'
  $('.top-menu ul li > ul').parent().hover (->
    $(this).children('ul').animate {
      opacity: 'show'
      padding: 'show'
      marginTop: '-1px'
    }, 'fast', 'linear'
    return
  ), ->
    $(this).children('ul').animate {
      opacity: 'hide'
      padding: 'hide'
      marginTop: '5px'
    }, 'fast', 'linear'
    return
  return