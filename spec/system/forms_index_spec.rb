# frozen_string_literal: true

require 'rails_helper'

describe 'interacting with forms/drafts from the index', js: true do
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
    context 'clicking the delete button' do
      it 'destroys drafts' do
        expect(page).to have_text @draft.name
        within('#form_drafts_table') do
          click_link 'Delete'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).not_to have_text @draft.name
        expect(FormDraft.count).to eql 0
        within('#flash') do
          expect(page).to have_text 'Draft has been discarded'
        end
      end
      it 'destroys forms' do
        expect(page).to have_text @form.name
        within('#forms_table') do
          click_link 'Delete'
        end
        page.driver.browser.switch_to.alert.accept
        expect(page).not_to have_text @form.name
        expect(Form.count).to eql 0
        within('#flash') do
          expect(page).to have_text 'Form successfully deleted'
        end
      end
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
      it 'has options in the index to resume editing or discard the draft' do
        click_button 'Save draft and preview changes'
        click_link 'Save draft & go back to index'
        draft = @form.draft_belonging_to(@user)
        expect(page).to have_link 'Resume editing saved draft',
          href: edit_form_draft_path(draft)
        expect(page).to have_button('Discard saved draft')
      end
    end
  end
end
