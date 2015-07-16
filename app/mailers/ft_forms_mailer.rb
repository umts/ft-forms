class FtFormsMailer < ActionMailer::Base
  default from: 'transit-it@admin.umass.edu'

  def send_confirmation(form_data)
    @form_data = form_data
    mail to: form_data.fetch('Email'),
         subject: 'Meet & Greet Request Confirmation'
    logger.info "Sent mail to #{form_data.fetch 'Email'}"
  end

  def send_form(form_data)
    @form_data = form_data
    mail to: 'fieldtrip@umass.edu',
         subject: 'New Meet & Greet Request'
    logger.info "Sent mail to fieldtrip@umass.edu"
  end
end
