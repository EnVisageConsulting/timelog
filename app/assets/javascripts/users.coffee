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

class UserForm
  constructor: ->
    @form = $('form.user-form')
    @roleField = @form.find("select[name$='[role]']")
    @partProjectField = @form.find("select[name$='[partner_project_ids][]']")
    @partTagField = @form.find("select[name$='[partner_tag_ids][]']")
    @partFields = @partProjectField.add(@partTagField)
    @setup()

  setup: ->
    @roleField.on "change", => @togglePartnerField()

    @togglePartnerField()

  togglePartnerField: ->
    if @roleField.find("option:selected").text().toLowerCase() == "partner"
      @partFields.closest(".row").slideDown()
    else
      @partFields.closest(".row").hide()


$(document).on 'users_index.load', (e, obj) =>
  user = new User
  user.userList()

$(document).on 'users_new.load users_create.load users_edit.load users_update.load', =>
  new UserForm()