# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ft_forms_mailer/send_form.text.erb' do
  before do
    @form_data = [['a question', 'an answer'],
                  ['a heading', :heading],
                  %w[email my_email]]
    @req_user = create :user
  end

  it 'includes the name and email of the user who made the request' do
    render
    expect(rendered).to include @req_user.full_name
    expect(rendered).to include @req_user.email
  end

  it 'includes the text of the email' do
    render
    expect(rendered).to include 'Meet & Greet request'
  end

  it 'includes the form data of the request' do
    render
    expect(rendered).to include 'a question: an answer'
    'email: my_email'
  end

  it 'only displays the heading and not the associated :heading' do
    render
    expect(rendered).not_to include 'a heading: heading'
  end
end
