# frozen_string_literal: true

require 'rails_helper'

describe 'creating a draft', js: true do
  before :each do
    login_as(create :user, :staff)
    visit '/forms'
    click_link 'New form'
    fill_in 'form_draft[name]', with: 'General Fletcher'
    fill_in 'form_draft[email]', with: 'fletcher@example.com'
    fill_in 'form_draft[fields_attributes][0][prompt]', with: 'When?'
    select 'date', from: 'form_draft[fields_attributes][0][data_type]'
  end
  context 'saving a draft' do
    before :each do
      click_button 'Save draft and preview changes'
      expect(page).to have_text 'When?'
    end
    context 'without publishing the form' do
      it 'displays it on the index page for later' do
        click_link 'Save draft & go back to index'
        expect(page).to have_css 'h1', text: 'Unpublished Drafts'
        expect(page).to have_text 'General Fletcher'
        expect(FormDraft.count).to eql 1
      end
    end
    context 'continuing to edit' do
      it 'brings you back to the edit page for that draft' do
        click_link 'Continue editing'
        expect(page).to have_current_path edit_form_draft_path(FormDraft.last)
      end
    end
    context 'publishing the form' do
      it 'discards the draft and creates a form' do
        click_button 'Publish form and discard draft'
        expect(page).to have_css 'h1', text: 'Forms'
        expect(page).to have_text 'General Fletcher'
        expect(FormDraft.count).to eql 0
        expect(Form.count).to eql 1
        expect(page).to have_current_path forms_path
      end
    end
  end
  context 'deciding not to create a form or a draft' do
    it 'deletes the draft' do
      click_button 'Cancel'
      expect(page).not_to have_css 'h1', text: 'Unpublished Drafts'
      expect(page).not_to have_text 'General Fletcher'
      expect(FormDraft.count).to eql 0
      expect(page).to have_current_path forms_path
    end
  end
end
