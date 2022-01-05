# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'forms/thank_you.haml' do
  subject(:page) { rendered }

  before { render }

  it { is_expected.to have_tag('h1', text: 'Thank you!') }

  it { is_expected.to include('Your request has been processed') }

  it { is_expected.to include('and you should receive') }

  it { is_expected.to include('a confirmation email shortly.') }
end
