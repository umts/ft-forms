# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'viewing a draft' do
  let(:user) { create :user, :staff }
  let(:draft) do
    create :form_draft, :with_fields, email: 'draft.email@test.host'
  end

  before do
    when_current_user_is user
    visit "form_drafts/#{draft.id}"
  end

  it 'has a form submitting to submit form path, but with disabled submit' do
    expect(page).to have_button('Submit request', disabled: true)
  end

  it 'contains the name of the form draft' do
    expect(page).to have_css 'h1', text: draft.name
  end

  it 'has a form preview message' do
    explanation = 'This is a preview of your changes. This form, as shown ' \
      'here, is not live.'
    expect(page).to have_text explanation
  end

  it 'has a email destination message' do
    message = "This form will email to '#{draft.email}'"
    expect(page).to have_text message
  end

  it 'displays all the prompts of the fields' do
    draft.fields.each do |field|
      expect(page).to have_content field.prompt
    end
  end

  it 'fills in the user fields with the current user first name' do
    expect(page).to have_field 'First name', with: user.first_name
  end

  it 'fills in the user fields with the current user last name' do
    expect(page).to have_field 'Last name', with: user.last_name
  end

  it 'fills in the user fields with the current user email' do
    expect(page).to have_field 'Email', with: user.email
  end

  it 'has a "continue editing" action button' do
    expect(page).to have_link 'Continue editing'
  end

  it 'has a "save and go back" action button' do
    expect(page).to have_link 'Save draft & go back to index'
  end

  it 'has a "cancel and discard" action button' do
    expect(page).to have_button 'Cancel and discard draft'
  end

  it 'has a "publish and discard" action button' do
    expect(page).to have_button 'Publish form and discard draft'
  end
end
