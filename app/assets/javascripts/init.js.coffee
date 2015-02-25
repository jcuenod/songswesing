myLightboxChart = undefined
myFeatherBox = undefined
tagOptions = []
update_original_var = undefined

ceAfterUpdate = (el) ->
  trueColor = $(el).css('backgroundColor')
  $(el).animate { backgroundColor: '#cce2ff' },
    duration: 100
    complete: ->
      # reset
      $(el).delay(10).animate { backgroundColor: trueColor }, duration: 900
      return
  return

ceDoUpdate = ->
  if update_original_var == $(this).html()
    return
  dataToSend = undefined
  dataToSend =
    key: $(this).attr('name')
    value: $(this).text().trim()
  toupdate = this
  $.ajax
    type: 'PUT'
    url: '/' + $('table.masteredit').attr('id') + '/' + $(this).parent('tr').attr('id')
    data: dataToSend
    dataType: 'JSON'
    success: (data) ->
      console.log data
      if data.result
        ceAfterUpdate $(toupdate)
        $(toupdate).siblings('td').each ->
          if $(this).text() != ""+data.object[$(this).attr('name')] and !!$(this).text() and !!data.object[$(this).attr('name')] and typeof data.object[$(this).attr('name')] != 'undefined'
            $(this).text data.object[$(this).attr('name')]
            ceAfterUpdate $(this)
          return
      else
        $(toupdate).text update_original_var
        console.log 'You should check rails logs because something went wrong with that update'
        trueColor = $(toupdate).css('backgroundColor')
        $(toupdate).animate { backgroundColor: '#ffe2cc' },
          duration: 100
          complete: ->
            # reset
            $(toupdate).delay(10).animate { backgroundColor: trueColor }, duration: 900
            return
      return
  return

ceBeforeUpdate = ->
  update_original_var = $(this).html()
  return

cePaste = (el) ->
  that = this
  setTimeout (->
    $(that).html $(that).text()
    return
  ), 10
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

songAnchorClicked = ->
  song_id = $(this).attr('id')
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

leaderAnchorClicked = ->
  jqxhr = $.post('/leaders/data/' + $(this).attr("id")).done((data) ->
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
  ).fail (e) ->
    console.log 'error'
    console.dir e
    return
  return

handleBusy = (xhr) ->
  if $(xhr.target).is("form")
    #form is being submitted make things look pretty in the mean time
    myFeatherBox.close()
    myFeatherBox = $.featherlight "<div class='ajaxbusy' />"
  return

handleComplete = (xhr, response, status) ->
  myFeatherBox.close() if myFeatherBox?
  if $(xhr.target).hasClass "crud_create"
    #creation button hit
    myFeatherBox = $.featherlight response.responseText, afterOpen: ->
      $('form#frm_create').validate()
      $('#frm_create input[type!=hidden]').first().focus()
      return
  else if $(xhr.target).hasClass "crud_delete"
    #destroy button hit
    $('tr#' + response.responseJSON.aka_id).fadeOut 'slow', ->
      $(this).remove()
      return
    return
  else if $(xhr.target).is("form")
    #form submission
    switch response.responseJSON.what
      when 'created'
        switch response.responseJSON.whatCreated
          when 'service'
            $('.insertionForm').after response.responseJSON.htmlOutput
          when 'leader'
            $('#service_leader_id').append response.responseJSON.htmlOutput
          when 'service_type'
            $('#service_service_type_id').append response.responseJSON.htmlOutput
          when 'song'
            $('#songList').tagit 'createTag', response.responseJSON.tag.id, response.responseJSON.tag.label
          when 'aka'
            new_aka_song_id = response.responseJSON.song_id
            $.ajax
              'url': '/akas/' + response.responseJSON.aka_id
              'success': (newAkaTemplate) ->
                $(newAkaTemplate).insertAfter($('td[data-song-id=' + new_aka_song_id + ']').last().parent('tr'))
                  .on('focus', ceBeforeUpdate).on('blur', ceDoUpdate)
                  .on('paste', cePaste)
                return

$(document).on('ajax:complete', handleComplete)
$(document).on('ajax:send', handleBusy)

$(document).on 'ready page:load', ->
  # $(document).on('ajax:complete', handleSuccess).on 'ajax:error', (xhr, status, error) ->
  #   console.log error
  #   alert 'failed'
  #   return
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
  $('a.songUsageAnchor').click songUsageAnchorClicked
  $('a.songAnchor').click songAnchorClicked
  $('a.leaderAnchor').click leaderAnchorClicked
  #$('a.crud_create').click createAnchorClicked #these should now be dealt with in the rails way
  #$('a.crud_delete').click deleteAnchorClicked
  $('td[contenteditable=true]').on('focus', ceBeforeUpdate).on 'blur', ceDoUpdate
  $('td[contenteditable=true]').on 'paste', cePaste
  return