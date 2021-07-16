# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'creating a draft' do
  before do
    when_current_user_is :staff
    visit '/forms'
    click_link 'New form'
    fill_in 'Form title', with: 'General Fletcher'
    fill_in 'Form email destination', with: 'fletcher@example.com'
    fill_in 'form_draft[fields_attributes][0][prompt]', with: 'When?'
    select 'date', from: 'form_draft[fields_attributes][0][data_type]'
  end

  context 'with the draft saved' do
    before { click_button 'Save draft and preview changes' }

    it 'has the questions' do
      expect(page).to have_text 'When?'
    end

    context 'without publishing the form' do
      before { click_link 'Save draft & go back to index' }

      it 'keeps the form draft' do
        expect(FormDraft.count).to be 1
      end

      it 'shows that there are unpublished drafts' do
        expect(page).to have_css 'h1', text: 'Unpublished Drafts'
      end

      it 'displays the draft on the index page for later' do
        expect(page).to have_text 'General Fletcher'
      end
    end

    context 'when continuing to edit the draft' do
      before { click_link 'Continue editing' }

      it 'brings you back to the edit page for that draft' do
        expect(page).to have_current_path edit_form_draft_path(FormDraft.last)
      end
    end

    context 'when publishing the form' do
      before { click_button 'Publish form and discard draft' }

      it 'redirects to the index' do
        expect(page).to have_current_path forms_path
      end

      it 'discards the draft' do
        expect(FormDraft.count).to be 0
      end

      it 'creates a form' do
        expect(Form.count).to be 1
      end

      it 'shows that there are forms' do
        expect(page).to have_css 'h1', text: 'Forms'
      end

      it 'displays the form' do
        expect(page).to have_text 'General Fletcher'
      end
    end
  end

  context 'when deciding not to create a form or a draft' do
    before { click_button 'Cancel' }

    it 'redirects to the index' do
      expect(page).to have_current_path forms_path
    end

    it 'deletes the draft' do
      expect(FormDraft.count).to be 0
    end

    it 'does not show that there are any drafts' do
      expect(page).not_to have_css 'h1', text: 'Unpublished Drafts'
    end

    it 'does not show the draft' do
      expect(page).not_to have_text 'General Fletcher'
    end
  end
end
