# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'interacting with forms/drafts from the index' do
  context 'when the user is not staff' do
    before do
      when_current_user_is :not_staff
      visit '/forms'
    end

    it 'does not allow access' do
      warning = 'You do not have permission to access this page'
      expect(page).to have_css 'h1', text: warning
    end
  end

  context 'when the user is staff' do
    let(:user) { create :user, :staff }
    let!(:form) { create :form, :with_fields }
    let!(:draft) { create :form_draft, user: user }

    before do
      when_current_user_is user
      visit '/forms'
    end

    context 'when clicking a delete button', js: true do
      def click_delete_in(selector)
        within selector do
          accept_alert { click_link 'Delete' }
        end
        find('body')
      end

      it 'destroys drafts' do
        click_delete_in '#form-drafts-table'
        expect(FormDraft.count).to be 0
      end

      it 'does not display destroyed drafts' do
        click_delete_in '#form-drafts-table'
        expect(page).not_to have_text draft.name
      end

      it 'informs you of the draft deletion' do
        click_delete_in '#form-drafts-table'
        within('#flash') do
          expect(page).to have_text 'Draft has been discarded'
        end
      end

      it 'destroys forms' do
        click_delete_in '#forms-table'
        expect(Form.count).to be 0
      end

      it 'does not display destroyed forms' do
        click_delete_in '#forms-table'
        expect(page).not_to have_text form.name
      end

      it 'informs you of the form deletion' do
        click_delete_in '#forms-table'
        within('#flash') do
          expect(page).to have_text 'Form successfully deleted'
        end
      end
    end

    context 'when clicking the edit button in the forms table' do
      before do
        within('#forms-table') { click_link 'Edit' }
      end

      it 'creates a draft for the form and goes to the draft edit page' do
        draft = form.draft_belonging_to(user)
        expect(page).to have_current_path edit_form_draft_path(draft)
      end

      it 'then has the option in the index to resume editing the draft' do
        draft = form.draft_belonging_to(user)
        click_button 'Save draft and preview changes'
        click_link 'Save draft & go back to index'
        expect(page).to have_link 'Resume editing saved draft',
                                  href: edit_form_draft_path(draft)
      end

      it 'then has the option in the index to discard the draft' do
        click_button 'Save draft and preview changes'
        click_link 'Save draft & go back to index'
        expect(page).to have_button('Discard saved draft')
      end
    end
  end
end
