# frozen_string_literal: true

class FtFormsMailer < ApplicationMailer
  include ApplicationHelper

  def send_confirmation(user, data, reply_to)
    @form_data = parse_form_data(data)
    # TODO: configure email from form
    mail to: user.email,
         subject: 'Meet & Greet Request Confirmation',
         reply_to: reply_to
  end

  def send_form(form, data, requesting_user)
    @form_data = parse_form_data(data)
    @req_user = requesting_user
    # TODO: configure email from form
    mail to: form.email,
         subject: 'New Meet & Greet Request'
  end
end
