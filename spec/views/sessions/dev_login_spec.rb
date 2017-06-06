# frozen_string_literal: true

require 'rails_helper'
include RSpecHtmlMatchers

describe 'sessions/dev_login.haml' do
  before :each do
    @staff = create :user, staff: true
    @not_staff = create :user
    assign :staff, Array(@staff)
    assign :not_staff, Array(@not_staff)
  end
  it 'has a button to login with a spire but no user record' do
    render
    expect(rendered).to have_form dev_login_path, :post do
      with_hidden_field 'spire' do
        with_tag 'input', name: 'commit'
      end
    end
  end
  it 'has a button to login with no spire or user record' do
    render
    expect(rendered).to have_form dev_login_path, :post do
      without_hidden_field 'spire', with: { tag: 'input', name: 'commit' }
    end
  end
  it 'displays a button to login for each staff user' do
    render
    expect(rendered).to have_form dev_login_path, :post do
      with_hidden_field 'user_id', @staff.id
    end
  end
  it 'displays a button to login for each non staff user' do
    render
    expect(rendered).to have_form dev_login_path, :post do
      with_hidden_field 'user_id', @not_staff.id
    end
  end
end
