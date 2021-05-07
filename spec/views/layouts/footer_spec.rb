# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/_footer.haml' do
  subject(:footer) { rendered }

  before { render }

  it { is_expected.to have_tag('span.content') }

  it { is_expected.to include(Time.zone.now.year.to_s) }

  it { is_expected.to have_tag 'a', with: { href: 'http://umass.edu' } }

  it 'links to the correct Site Policies URL' do
    expect(rendered).to have_tag 'a', with: { href: 'http://umass.edu/site_policies' } do
      with_text 'Site Policies'
    end
  end

  it 'has us as the Site Contact Email' do
    expect(rendered).to have_tag 'a', with: { href: 'mailto:transit-it@admin.umass.edu' } do
      with_text 'Site Contact'
    end
  end
end
