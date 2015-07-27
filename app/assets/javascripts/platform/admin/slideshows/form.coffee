class AdminSlideshowForm
  constructor: ->
    @slides_list = $(".js-admin-slides-list")
    @slides_list.sortable(
      update: @submit_slide_positions
    )

  submit_slide_positions: (event, ui) =>
    data = []
    counter = 0

    @slides_list.find("li.slide").each ->
      data.push({
        id: $(this).attr('data-id'),
        position: counter
      })
      counter += 1

    $.ajax
      type: 'POST'
      url: '/admin/admin/slides/positions'
      data: {slides: data}
      success: (response) =>
        ui.item.find('.thumbnail').effect('highlight', {}, 1000)

window.AdminSlideshowForm = AdminSlideshowForm