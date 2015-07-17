require 'rails_helper'
include RSpecHtmlMatchers

describe 'form_drafts/show.haml' do
  before :each do
    @draft = create :form_draft
  end
  it 'contains the name of the form draft' do
    render
    expect(rendered).to have_tag 'h1', with: { class: 'title' } do
      with_text(/#{@draft.name}/)
    end
  end
  it 'gives headings a class of heading' do 
    heading_field = create :field, form_draft: @draft, data_type: 'heading'
    render
    expect(rendered).to have_tag 'div', with: { class: 'heading' } do
     with_text(/#{heading_field.prompt}/)
    end
  end
  it 'gives explanations a class of explanation' do
    explanation_field = create :field, form_draft: @draft, data_type: 'explanation'
    render
    expect(rendered).to have_tag 'div', with: { class: 'explanation' } do
      with_text(/#{explanation_field.prompt}/)
    end
  end
  it 'gives a label to date/time fields' do
    date_time_field = create :field, form_draft: @draft, data_type: 'date/time'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{date_time_field.prompt}/)
      end
    end
  end
  it 'gives date/time fields a class of datetimepicker' do
    date_time_field = create :field, form_draft: @draft, data_type: 'date/time'
    render
    expect(rendered).to have_tag 'input', with: { class: 'datetimepicker' }
  end
  it 'gives a label to date fields' do
    date_field = create :field, form_draft: @draft, data_type: 'date'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{date_field.prompt}/)
      end
    end
  end
  it 'gives date fields a class of datepicker' do
    date_field = create :field, form_draft: @draft, data_type: 'date'
    render
    expect(rendered).to have_tag 'input', with: { class: 'datepicker' }
  end
  it 'gives a label to text fields' do
    text_field = create :field, form_draft: @draft, data_type: 'text'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{text_field.prompt}/)
      end
    end
  end
  it 'makes a text field from a field of type text' do
    text_field = create :field, form_draft: @draft, data_type: 'text'
    render
    expect(rendered).to have_tag 'input', with: { type: 'text' }
  end
  it 'gives a label to time fields' do
    time_field = create :field, form_draft: @draft, data_type: 'time'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{time_field.prompt}/)
      end
    end
  end
  it 'gives time fields a class of timepicker' do
    time_field = create :field, form_draft: @draft, data_type: 'time'
    render
    expect(rendered).to have_tag 'input', with: { class: 'timepicker' }
  end
  it 'gives a label to long-text fields' do
    long_text_field = create :field, form_draft: @draft, data_type: 'long-text'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{long_text_field.prompt}/)
      end
    end
  end
  it 'gives an input box for a long-text field' do
    long_text_field = create :field, form_draft: @draft, data_type: 'long-text'
    render
    expect(rendered).to have_tag 'textarea'
  end
  it 'gives a label to number fields' do
    number_field = create :field, form_draft: @draft, data_type: 'number'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{number_field.prompt}/)
      end
    end
  end
  it 'makes an input for number fields' do
    number_field = create :field, form_draft: @draft, data_type: 'number'
    render
    expect(rendered).to have_tag 'input'
  end
  it 'gives a label to yes/no fields' do
    yes_no_field = create :field, form_draft: @draft, data_type: 'yes/no'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text yes_no_field.prompt
      end
    end
  end
  it 'makes a radio button for yes/no fields' do
    yes_no_field = create :field, form_draft: @draft, data_type: 'yes/no'
    render
    expect(rendered).to have_tag 'input', with: { type: 'radio' }
  end
  it 'gives a label to option fields' do
    option_field = create :field, form_draft: @draft, data_type: 'options'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text option_field.prompt
      end
    end
  end
  it 'makes selectable options for option fields' do
    option_field = create :field, form_draft: @draft, data_type: 'options', options: %w(car)
    render
    expect(rendered).to have_tag 'select' do
      with_tag 'option', with: { value: 'car' }
    end
  end
  it 'puts an asterisk next to required fields' do
    required_field = create :field, form_draft: @draft, required: true
    render
    expect(rendered).to have_tag 'span', with: { class: 'ast' }
  end
  it 'has a button to continue editing' do
    render
    action_path = edit_form_draft_path @draft
    expect(rendered).to have_form action_path, :get
  end
  it 'has a button to discard changes' do
    render
    action_path = form_draft_path @draft
    expect(rendered).to have_form action_path, :post do
      with_tag 'input', with: { value: 'delete' }
    end
  end
  it 'has a button to save the form' do
    render
    action_path = update_form_form_draft_path @draft
    expect(rendered).to have_form action_path, :post
  end
end
