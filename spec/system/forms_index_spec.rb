# frozen_string_literal: true

require 'rails_helper'

describe 'interacting with forms/drafts from the index' do
  context 'not staff' do
    it 'does not allow access' do
      login_as(create :user, :not_staff)
      visit '/forms'
      warning = 'You do not have permission to access this page'
      expect(page).to have_css 'h1', text: warning
    end
  end
  context 'staff' do
    before :each do
      @user = create :user, :staff
      @form = create :form, :with_fields
      @draft = create :form_draft, user: @user
      login_as(@user)
      visit '/forms'
    end
    context 'clicking the edit button in the forms table' do
      before :each do
        within('#forms_table') do
          click_link 'Edit'
        end
      end
      it 'creates a draft for the form and goes to the draft edit page' do
        draft = @form.draft_belonging_to(@user)
        expect(page).to have_current_path edit_form_draft_path(draft)
        expect(page).to have_css 'h1', text: 'Editing ' + @form.name
      end
    end
  end
end
