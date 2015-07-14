class PostEditLocking
  constructor: ->
    @status_uri = window.post_edit_status_uri
    @interval = window.post_status_interval
    @editor_id = window.post_editor_id
    @user_id = window.user_id

    @was_editor = (@editor_id == @user_id)

    # if the current user is NOT the locker of the post,
    # we want him to poll at a less frequent interval
    # to give the locker space in the case that
    # they have a momentary network hiccup and can't lock
    # on first attempt
    if !@was_editor
      @interval += window.post_status_grace

    setInterval @push_status, @interval

  push_status: =>
    # attempt lock...
    $.post @status_uri, (response) =>
      if !@was_editor && response.edit_lock_succeeded
        if confirm "#{response.editor_byline} has finished editing this post. Click OK to refresh this page and view the updated post content."
          window.location.reload()

        @was_editor = true

      # ensure lock message is always shown when another user locks the post
      if response.editor_is_self != true
        $(".editing-user-name").html(response.editor_byline)
        $("#post-locked-message").removeClass("hidden")


window.PostEditLocking = PostEditLocking
