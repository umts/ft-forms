include ApplicationHelper

class FtFormsMailer < ActionMailer::Base
  default from: 'transit-it@admin.umass.edu'
  default reply_to: 'fieldtrip@umass.edu'

  def send_confirmation(user, data)
    @form_data = parse_form_data(data)
    # TODO: configure email from form
    binding.pry
    mail to: user.email,
         subject: 'Meet & Greet Request Confirmation',
         reply_to: @form_data.reply_to
  end

  def send_form(form, data)
    @form_data = parse_form_data(data)
    # TODO: configure email from form
    mail to: form.email,
         subject: 'New Meet & Greet Request'
  end
end
