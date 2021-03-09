# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'fields/edit.haml' do
  before :each do
    @form_draft = create :form_draft
    @field = create :field, form_draft: @form_draft
  end
  it 'contains the field prompt' do
    render
    expect(rendered).to have_tag 'h1', with: { class: 'title' } do
      with_text(/#{@field.prompt}/)
    end
  end
  it 'contains a form to edit the field options' do
    render
    action_path = field_path @field
    expect(rendered).to have_form action_path, :post do
      with_text_area 'options'
    end
  end
end
