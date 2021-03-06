ready = ->
  # Quote button
  $('.quote-post').click (event) ->
    quoute_post_id = $(event.target).data('post-id')

    $.ajax
      url: '/post/' + quoute_post_id
      type: "GET"
      dataType: "json"
      success: (response) ->
        quote  = $('#quick_answer_textarea').val()
        quote += '\n[quote author=' + response.author+ ']'
        quote += response.text
        quote += '[/quote]\n\n'

        $('#quick_answer_textarea').val(quote)
        $('body').scrollTo($('#quick_answer_textarea'))


  # BBCode editor
  $('.text-editor-buttons').click (event) ->
    event.preventDefault()

    apply_to = $('.text-editor-buttons').data('apply-to')
    apply_to = $('#' + apply_to)

    # Smiles
    if $(event.target).attr('class').search('smile') >= 0
      smile_code = $(event.target).data('code') || $(event.target).find('[data-code]').data('code')

      if smile_code
        text = apply_to.val()
        apply_to.val(text + smile_code + ' ')

      return false


    # Text formatting
    return false if !$(event.target).is('a') and !$(event.target).is('i')

    button = if $(event.target).is('a') then $(event.target).find('i') else $(event.target)
    html_class = button.attr('class')

    action = if html_class then html_class.replace('fa fa-', '') else ''
    text = apply_to.val()

    switch action
      when 'bold'
        bbcode = '[b] [/b]'
      when 'italic'
        bbcode = '[i] [/i]'
      when 'strikethrough'
        bbcode = '[s] [/s]'
      when 'underline'
        bbcode = '[u] [/u]'
      when 'link', 'video-camera', 'camera-retro'
        $('#add_photo').modal()
      else
        bbcode = ''
        console.log 'Unknown tag'

    if bbcode
      if (selected_text = apply_to.selection()).length > 0
        open_tag = bbcode.split(' ')[0]
        close_tag = bbcode.split(' ')[1]
        apply_to.selection('replace', { text: open_tag + selected_text + close_tag })
      else
        apply_to.val(text + bbcode + ' ')

  # Autocomplete
  $('.autocomplete').keyup (elm) ->
    ajax_url = $(@).data('autocomplete-path')
    return unless ajax_url

    $.ajax
      url: ajax_url
      type: "GET"
      dataType: "json"
      data: str: $(elm.target).val()
      success: (response) ->
        autocomplete_popup(response, elm.target)

autocomplete_popup = (autocomplete_list, object) ->
  popup_id = 'autocomplete_popup'

  # Create or use existing Popup Window
  if $('#' + popup_id).length > 0
    popup_container = $('#' + popup_id)
  else
    popup_container = $("<div id='#{popup_id}'></div>")
    $(object).after(popup_container)

  $('body').click ->
    popup_container.remove()

  # Show lists
  html_list = $('<ul/>')
  $.map autocomplete_list, (item) ->
    li = $('<li/>')
      .addClass('ui-menu-item')
      .attr('role', 'menuitem')
      .appendTo(html_list)

    a = $('<a/>')
      .addClass('ui-all')
      .text(item)
      .appendTo(li)

    li.click ->
      $(object).val(item)

      # Destroy popup after select tag
      popup_container.remove()

  popup_container.html(html_list)

$(document).ready(ready)
$(document).on('page:load', ready)