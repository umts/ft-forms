require 'rails_helper'
include RSpecHtmlMatchers

describe 'sessions/dev_login.haml' do
  before :each do
    staff = create :user, staff: true
    not_staff = create :user
    assign :staff, Array(staff)
    assign :not_staff, Array(not_staff)
  end
  it 'has a button to login with a spire but no user record' do
    render
    expect(rendered).to have_tag 'input', with: { name: 'spire' }
  end
  it 'has a button to login with no spire or user record'
  # this isn't different from above
  # doesn't fail... like you can totally log in, so
  # the view doesn't work. :(
  it 'displays a button to login for each staff member'
end
