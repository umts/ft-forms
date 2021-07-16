# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'creating a form', js: true do
  let(:field) { ->(attr) { "form_draft[fields_attributes][0][#{attr}]" } }
  let :save_and_publish do
    click_button 'Save draft and preview changes'
    click_button 'Publish form and discard draft'
  end

  before do
    when_current_user_is :staff
    visit '/forms'
    click_link 'New form'
    fill_in 'Form title', with: 'General Fletcher'
    fill_in 'Form email destination', with: 'fletcher@example.com'
    fill_in field['prompt'], with: 'When?'
  end

  context 'with a data type requiring a placeholder' do
    before do
      select 'text', from: field['data_type']
      fill_in field['placeholder'], with: 'example'
    end

    it 'saves the placeholder' do
      save_and_publish
      expect(Field.last.placeholder).to eq 'example'
    end
  end

  context 'with a data type of options' do
    before do
      select 'options', from: field['data_type']
      fill_in field['options'], with: 'puppies$kittens, ponies snakes,birdies'
    end

    it 'saves the options with any separator' do
      save_and_publish
      expect(Field.last.options).to eq %w[puppies kittens ponies snakes birdies]
    end
  end

  context 'with a required question' do
    before do
      select 'text', from: field['data_type']
      check field['required']
    end

    it 'saves the required attribute' do
      save_and_publish
      expect(Field.last.required).to be true
    end
  end
end
