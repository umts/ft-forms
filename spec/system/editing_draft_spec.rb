# frozen_string_literal: true

require 'rails_helper'

describe 'editing a draft', js: true do
  before :each do
    login_as(create :user, :staff)
    visit '/forms'
    click_link 'New form'
  end
  context 'manipulating fields' do
    it 'allows the addition, deletion, and moving of fields' do
      expect(page).to have_css('.row.padded-field', count: 1)
      find('#add-new').click
      expect(page).to have_css('.row.padded-field', count: 2)
      fill_in 'form_draft[fields_attributes][0][prompt]', with: 'First Question'
      fill_in 'form_draft[fields_attributes][1][prompt]', with: 'Next Question'
      second_field = find('.row.padded-field:nth-child(2)')
      first_field = find('.row.padded-field:nth-child(1)')
      second_field.drag_to first_field
      expect(find_field('form_draft[fields_attributes][0][prompt]').value).to eql 'Next Question'
      expect(find_field('form_draft[fields_attributes][1][prompt]').value).to eql 'First Question'
      second_field.find('.remove').click
      expect(page).to have_css('.row.padded-field', count: 1)
      expect(page).not_to have_field 'form_draft[fields_attributes][1][prompt]'
      expect(find_field('form_draft[fields_attributes][0][prompt]').value).to eql 'First Question'
    end
    it 'toggles the visibility of relevant fields given the data type' do
      select 'options', from: 'form_draft[fields_attributes][0][data_type]'
      expect(page).to have_field 'form_draft[fields_attributes][0][required]'
      expect(page).to have_field 'form_draft[fields_attributes][0][options]'
      expect(page).not_to have_field 'form_draft[fields_attributes][0][placeholder]'
      select 'text', from: 'form_draft[fields_attributes][0][data_type]'
      expect(page).not_to have_field 'form_draft[fields_attributes][0][options]'
      expect(page).to have_field 'form_draft[fields_attributes][0][required]'
      expect(page).to have_field 'form_draft[fields_attributes][0][placeholder]'
      select 'explanation', from: 'form_draft[fields_attributes][0][data_type]'
      expect(page).not_to have_field 'form_draft[fields_attributes][0][options]'
      expect(page).not_to have_field 'form_draft[fields_attributes][0][required]'
      expect(page).not_to have_field 'form_draft[fields_attributes][0][placeholder]'
    end
  end
end