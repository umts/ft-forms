# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/_umass_search.haml' do
  it 'has the form it needs to have' do
    action_path = 'https://googlebox.oit.umass.edu/search'
    render
    expect(rendered).to have_form action_path,
                                  :get,
                                  with: { id: 'banner-search', name: 'gs' } do
      with_tag 'div' do
        with_tag 'label', with: { for: 'q' }
        with_tag 'input#q', with: { type: 'text',
                                    placeholder: 'Search UMass',
                                    size: 22 }
      end
      with_hidden_field 'site', 'default_collection'
      with_hidden_field 'client', 'default_frontend'
      with_hidden_field 'proxystylesheet', 'default_frontend'
      with_hidden_field 'output', 'xml_no_dtd'
    end
  end
end
