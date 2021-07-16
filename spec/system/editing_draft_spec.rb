# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'editing a draft' do
  let(:field) do
    ->(index, name) { "form_draft[fields_attributes][#{index}][#{name}]" }
  end

  before do
    when_current_user_is :staff
  end

  context 'when editing a new draft', js: true do
    before do
      visit '/forms'
      click_link 'New form'
    end

    context 'when adding or removing fields' do
      def add_field
        find('#add-new').click
      end

      def fill_in_fields
        fill_in field[0, 'prompt'], with: 'First Question'
        fill_in field[1, 'prompt'], with: 'Next Question'
      end

      def remove_field
        second_field = find('.row.padded-field:nth-child(2)')
        second_field.find('.remove').click
      end

      it 'has one field to start with' do
        expect(page).to have_css('.row.padded-field', count: 1)
      end

      it 'allows the addition of a field' do
        add_field
        expect(page).to have_css('.row.padded-field', count: 2)
      end

      it 'allows the removal of a field' do
        add_field
        fill_in_fields
        remove_field
        expect(page).to have_css('.row.padded-field', count: 1)
      end

      it 'removes the correct field' do
        add_field
        fill_in_fields
        remove_field
        expect(page).not_to have_field(field[1, 'prompt'])
      end

      it 'keeps the correct value' do
        add_field
        fill_in_fields
        remove_field
        expect(page).to have_field(field[0, 'prompt'], with: 'First Question')
      end
    end

    it 'allows fields to be moved'
    # testing this functionality was attempted with the code below, but it
    # fails on Travis, probably due to Capybara's drag_to method not being
    # appropriate for JQuery's #sortable. Reimplement when another option
    # becomes available.
    # first_field = find('.row.padded-field.ui-sortable-handle:nth-child(1)')
    # first_field.drag_to second_field
    # expect(find_field('form_draft[fields_attributes][0][prompt]').value)
    #   .to eql 'Next Question'
    # expect(find_field('form_draft[fields_attributes][1][prompt]').value)
    #   .to eql 'First Question'

    it 'shows the required checkbox for "options" fields' do
      select 'options', from: field[0, 'data_type']
      expect(page).to have_field field[0, 'required']
    end

    it 'shows the options field for "options" fields' do
      select 'options', from: field[0, 'data_type']
      expect(page).to have_field field[0, 'options']
    end

    it 'does not show the placeholder field for "options" fields' do
      select 'options', from: field[0, 'data_type']
      expect(page).not_to have_field field[0, 'placeholder']
    end

    it 'shows the required checkbox for text fields' do
      select 'text', from: field[0, 'data_type']
      expect(page).to have_field field[0, 'required']
    end

    it 'does not show the options field for text fields' do
      select 'text', from: field[0, 'data_type']
      expect(page).not_to have_field field[0, 'options']
    end

    it 'shows the placeholder field for text fields' do
      select 'text', from: field[0, 'data_type']
      expect(page).to have_field field[0, 'placeholder']
    end

    it 'does not show the required checkbox for explanations' do
      select 'explanation', from: field[0, 'data_type']
      expect(page).not_to have_field field[0, 'required']
    end

    it 'does not show not show the options field for explanations' do
      select 'explanation', from: field[0, 'data_type']
      expect(page).not_to have_field field[0, 'options']
    end

    it 'does not show the placeholder field for explanations' do
      select 'explanation', from: field[0, 'data_type']
      expect(page).not_to have_field field[0, 'placeholder']
    end
  end

  context 'when editing an existing draft' do
    let(:form) { create :form }

    before do
      create :field, data_type: 'options', options: %w[red blue], form: form
      visit '/forms'
      click_link 'Edit'
    end

    it 'contains the name of the form' do
      expect(page).to have_css 'h1', text: "Editing #{form.name}"
    end

    it 'has a prompt input for the field' do
      expect(page).to have_field field[0, 'prompt']
    end

    it 'has a data-type input for the field' do
      expect(page).to have_field field[0, 'data_type']
    end

    it 'has an options input with values for the field' do
      expect(page).to have_field(field[0, 'options'], text: 'red, blue')
    end
  end
end
