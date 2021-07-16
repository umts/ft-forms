# frozen_string_literal: true

require 'form_data_parser'

class FtFormsMailer < ApplicationMailer
  def send_confirmation(user, data, reply_to)
    @form_data = FormDataParser.new(data).process!
    # TODO: configure email from form
    mail to: user.email, reply_to: reply_to,
         subject: 'Meet & Greet Request Confirmation'
  end

  def send_form(form, data, requesting_user)
    @form_data = FormDataParser.new(data).process!
    @req_user = requesting_user
    # TODO: configure email from form
    mail to: form.email, subject: 'New Meet & Greet Request'
  end
end
