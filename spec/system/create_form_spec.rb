# frozen_string_literal: true

require 'rails_helper'

describe 'creating a form', js: true do
  before :each do
    when_current_user_is :staff
    visit '/forms'
    click_link 'New form'
    fill_in 'form_draft[name]', with: 'General Fletcher'
    fill_in 'form_draft[email]', with: 'fletcher@example.com'
    fill_in 'form_draft[fields_attributes][0][prompt]', with: 'When?'
    @data_field = 'form_draft[fields_attributes][0][data_type]'
  end
  context 'with a data type requiring a placeholder' do
    it 'saves the placeholder' do
      select 'text', from: @data_field
      fill_in 'form_draft[fields_attributes][0][placeholder]', with: 'example'
      click_button 'Save draft and preview changes'
      click_button 'Publish form and discard draft'
      expect(Field.last.placeholder).to eql 'example'
    end
  end
  context 'with a data type of options' do
    it 'saves the options with any separator' do
      select 'options', from: @data_field
      fill_in 'form_draft[fields_attributes][0][options]',
              with: 'puppies$kittens, ponies snakes,birdies'
      click_button 'Save draft and preview changes'
      click_button 'Publish form and discard draft'
      expect(Field.last.options)
        .to eql %w[puppies kittens ponies snakes birdies]
    end
  end
  context 'a required question' do
    it 'saves the required attribute' do
      select 'text', from: @data_field
      check 'form_draft[fields_attributes][0][required]'
      click_button 'Save draft and preview changes'
      click_button 'Publish form and discard draft'
      expect(Field.last.required).to be true
    end
  end
end
