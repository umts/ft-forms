require 'rails_helper'
include RSpecHtmlMatchers

describe 'fields/edit.haml' do
  before :each do
    @form_draft = create :form_draft
    @field = create :field, form_draft: @form_draft 
  end
  it 'contains the name of the field' do
    render
    expect(rendered).to have_tag 'h1', with: { class: 'title' }
  end
  it 'contains a form to edit the field options' do
    render
    action_path = field_path @field
    expect(rendered).to have_form action_path, :post do
      with_text_area 'options'
    end
  end
end
