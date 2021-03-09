# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'forms/thank_you.haml' do
  it 'has an h1 tag saying thanks' do
    render
    expect(rendered).to have_tag 'h1' do
      with_text 'Thank you!'
    end
  end
  it 'has some other text' do
    render
    expect(rendered).to include 'Your request has been processed'
    expect(rendered).to include 'and you should receive'
    expect(rendered).to include 'a confirmation email shortly.'
  end
end
