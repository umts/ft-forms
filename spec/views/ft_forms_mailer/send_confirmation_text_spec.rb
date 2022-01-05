# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ft_forms_mailer/send_confirmation.text.erb' do
  subject(:message) { rendered }

  before do
    assign :form_data, { question1: 'answer1', email: 'my_email' }
    render
  end

  it { is_expected.to include('UMass Transit Meet & Greet Service') }

  it { is_expected.to include('Please do not reply to this email') }

  it { is_expected.to include('question1: answer1', 'email: my_email') }
end
