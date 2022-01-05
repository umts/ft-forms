# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ft_forms_mailer/send_form.text.erb' do
  subject(:message) { rendered }

  let(:req_user) { create :user }

  before do
    assign :form_data,
           [['a question', 'an answer'], ['a heading', :heading], %w[email my_email]]
    assign :req_user, req_user
    render
  end

  it { is_expected.to include(req_user.full_name, req_user.email) }

  it { is_expected.to include('Meet & Greet request') }

  it { is_expected.to include('a question: an answer') }

  it 'only displays the heading and not the associated :heading' do
    expect(rendered).not_to include 'a heading: heading'
  end
end
