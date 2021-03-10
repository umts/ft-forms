# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'editing a draft' do
  before :each do
    when_current_user_is :staff
  end
  context 'edting a new draft', js: true do
    before :each do
      visit '/forms'
      click_link 'New form'
    end
    context 'manipulating fields' do
      it 'allows the addition and deletion of fields' do
        expect(page).to have_css('.row.padded-field', count: 1)
        find('#add-new').click
        expect(page).to have_css('.row.padded-field', count: 2)
        fill_in 'form_draft[fields_attributes][0][prompt]',
                with: 'First Question'
        fill_in 'form_draft[fields_attributes][1][prompt]',
                with: 'Next Question'
        second_field = find('.row.padded-field.ui-sortable-handle:nth-child(2)')
        second_field.find('.remove').click
        expect(page).to have_css('.row.padded-field', count: 1)
        expect(page).not_to have_field(
          'form_draft[fields_attributes][1][prompt]'
        )
        expect(find_field('form_draft[fields_attributes][0][prompt]').value)
          .to eql 'First Question'
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

      it 'toggles the visibility of relevant fields given the data type' do
        field_row = 'form_draft[fields_attributes][0]'
        select 'options', from: "#{field_row}[data_type]"
        expect(page).to have_field "#{field_row}[required]"
        expect(page).to have_field "#{field_row}[options]"
        expect(page).not_to have_field "#{field_row}[placeholder]"
        select 'text', from: "#{field_row}[data_type]"
        expect(page).not_to have_field "#{field_row}[options]"
        expect(page).to have_field "#{field_row}[required]"
        expect(page).to have_field "#{field_row}[placeholder]"
        select 'explanation', from: "#{field_row}[data_type]"
        expect(page).not_to have_field "#{field_row}[options]"
        expect(page).not_to have_field "#{field_row}[required]"
        expect(page).not_to have_field "#{field_row}[placeholder]"
      end
    end
  end

  context 'editing an existing draft' do
    before :each do
      @form = create :form
      @field = create :field,
                      data_type: 'options',
                      options: %w[red blue],
                      form: @form
      visit '/forms'
      click_link 'Edit'
    end

    it 'contains the name of the form' do
      expect(page).to have_css 'h1', text: "Editing #{@form.name}"
    end

    it 'has inputs and values for each field ' do
      expect(page).to have_field 'form_draft[fields_attributes][0][prompt]'
      expect(page).to have_field 'form_draft[fields_attributes][0][data_type]'
      expect(page).to have_field 'form_draft[fields_attributes][0][options]',
                                 text: 'red, blue'
    end
  end
end
