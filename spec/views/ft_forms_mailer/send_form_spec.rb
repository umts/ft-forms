require 'rails_helper'
include RSpecHtmlMatchers

describe 'ft_forms_mailer/send_form.text.erb' do
  before :each do
    @form_data = Hash[question1: 'answer1', question2: 'answer2', email: 'my_email']
  end
  it 'includes the text of the email' do
    render
    expect(rendered).to include 'Meet & Greet request'
  end
  it 'includes the form data of the request' do
    render
    expect(rendered).to include 'question1: answer1',
                                'question2: answer2',
                                'email: my_email'
  end
end
