class CharacterCounter
  constructor: (@el) ->
    @inject_counter()
    @bind_events()
    @adjust_count()

  bind_events: =>
    @el.keyup @adjust_count

  adjust_count: =>
    count = @el.val().length
    title = if count == 1 then 'character' else 'characters'
    @counter_el.html("#{count} #{title}")

  inject_counter: =>
    group = @el.parents(".form-group")
    @counter_wrap = $("
      <div class='character-count-wrap'>
        <span class='count'></span>
      </div>
    ")
    group.prepend(@counter_wrap)
    @counter_el = @counter_wrap.find('.count')

$ ->
  $("[data-toggle='character-counter']").each -> new CharacterCounter($(this))

