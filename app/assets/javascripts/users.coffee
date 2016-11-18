class User
  userList: ->
    $links = $(".deactivate-link")
    emptyClass = 'fa-battery-1'
    fullClass = 'fa-battery-full'

    # toggle battery full and empty classes
    $links.hover ->
      $link = $(this)
      $link.find '.fa'
           .toggleClass emptyClass
           .toggleClass fullClass


$(document).on 'users_index.load', (e, obj) =>
  user = new User
  user.userList()