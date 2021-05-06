# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ft_forms_mailer/send_confirmation.text.erb' do
  before do
    @form_data = { question1: 'answer1', email: 'my_email' }
  end

  it 'includes the text of the email' do
    render
    expect(rendered).to include 'UMass Transit Meet & Greet Service'
  end

  it 'includes a note about not replying to transit-it' do
    render
    expect(rendered).to include 'Please do not reply to this email'
  end

  it 'includes the form data of the request' do
    render
    expect(rendered).to include 'question1: answer1',
                                'email: my_email'
  end
end
