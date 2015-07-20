require 'rails_helper'
include RSpecHtmlMatchers

describe 'ft_forms_mailer/send_confirmation.text.erb' do
  before :each do
    @form_data = Hash[question1: 'answer1', email: 'my_email']
  end
  it 'includes the text of the email' do
    render
    expect(rendered).to include 'UMass Transit Meet & Greet Service'
  end
  it 'includes the form data of the request' do
    render
    expect(rendered).to include 'question1: answer1',
                                'email: my_email'
  end
end
