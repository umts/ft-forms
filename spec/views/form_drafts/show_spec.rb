require 'rails_helper'
include RSpecHtmlMatchers

describe 'form_drafts/show.haml' do
  before :each do
    @draft = create :form_draft
    @heading_field     = create :field, form_draft: @draft, data_type: 'heading'
    @explanation_field = create :field, form_draft: @draft, data_type: 'explanation'
  end
  it 'contains the name of the form draft' do
    render
    expect(rendered).to have_tag 'h1', with: { class: 'title' } do
      with_text(/#{@draft.name}/)
    end
  end
  it 'gives headings a class of heading' do 
    render
    expect(rendered).to have_tag 'div', with: { class: 'heading' } do
     with_text(/#{@heading_field.prompt}/)
    end
  end
  it 'gives explanations a class of explanation' do
    render
    expect(rendered).to have_tag 'div', with: { class: 'explanation' } do
      with_text(/#{@explanation_field.prompt}/)
    end
  end
  it 'gives date/time fields a class of input_class' do
    @date_time_field = create :field, form_draft: @draft, data_type: 'date/time' 
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{@date_time_field.prompt}/)
      end
    end
  end
end
