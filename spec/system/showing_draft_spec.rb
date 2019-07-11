# frozen_string_literal: true

require 'rails_helper'

describe 'viewing a draft' do
  before :each do
    @user = create :user, :staff
    login_as(@user)
    email = 'draft.email@test.host'
    @form = create :form
    @draft = create :form_draft, :with_fields, form: @form, email: email
    visit "form_drafts/#{@draft.id}"
  end
  it 'has a form submitting to submit form path, but with disabled submit' do
    expect(page).to have_button('Submit request', disabled: true)
  end
  it 'contains the name of the form draft' do
    expect(page).to have_css 'h1', text: "#{@draft.name}"
  end
  it 'has a form preview message including the email value of the draft' do
    explanation = 'This is a preview of your changes. This form, as shown ' \
      'here, is not live.'
    message = "This form will email to '#{@draft.email}'"
    expect(page).to have_text message
    expect(page).to have_text explanation
  end
  it 'displays all the prompts of the fields' do
    @draft.fields.each do |field|
      expect(page).to have_content field.prompt
    end
  end
  it 'fills in the user fields with the current user info' do
    expect(page).to have_field 'First name', with: @user.first_name
    expect(page).to have_field 'Last name', with: @user.last_name
    expect(page).to have_field 'Email', with: @user.email
  end
  it 'has a lot of action buttons' do
    # actions are tested elsewhere
    expect(page).to have_link 'Continue editing'
    expect(page).to have_link 'Save draft & go back to index'
    expect(page).to have_button 'Cancel and discard draft'
    expect(page).to have_button 'Publish form and discard draft'
  end
end
