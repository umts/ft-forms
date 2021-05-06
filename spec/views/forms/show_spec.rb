# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'forms/show.haml' do
  before do
    @form = create :form
    assign :form, @form
  end

  let :main_form_path do
    submit_form_path @form.id
  end

  it 'has a form submitting to the submit form path' do
    render
    expect(rendered).to have_form main_form_path, :post
  end

  context 'submit is true' do
    before do
      assign :submit, true
    end

    it 'has an enabled submit button' do
      render
      expect(rendered).to have_form main_form_path, :post do
        without_tag 'input', with: { type: 'submit', disabled: true }
      end
    end
  end

  context 'submit is false' do
    before do
      assign :submit, false
    end

    it 'has a disabled submit button' do
      render
      expect(rendered).to have_form main_form_path, :post do
        with_tag 'input', with: { type: 'submit', disabled: 'disabled' }
      end
    end
  end

  context 'current user is present' do
    before do
      @user = create :user
      when_current_user_is @user
    end

    it 'fills in the user fields' do
      render
      expect(rendered).to have_form main_form_path, :post do
        with_text_field 'user[first_name]', @user.first_name
        with_text_field 'user[last_name]',  @user.last_name
        with_text_field 'user[email]',      @user.email
      end
    end
  end

  context 'current user is not present' do
    it 'does not fill in the user fields' do
      render
      expect(rendered).to have_form main_form_path, :post do
        with_text_field 'user[first_name]', nil
        with_text_field 'user[last_name]',  nil
        with_text_field 'user[email]',      nil
      end
    end
  end

  it 'contains the name of the form' do
    render
    expect(rendered).to have_tag 'h1', with: { class: 'title' } do
      with_text(/#{@form.name}/)
    end
  end

  it 'gives headings a class of heading' do
    heading_field = create :field, form: @form, data_type: 'heading'
    render
    expect(rendered).to have_tag 'div', with: { class: 'heading' } do
      with_text(/#{heading_field.prompt}/)
    end
  end

  it 'gives explanations a class of explanation' do
    explanation_field = create :field, form: @form, data_type: 'explanation'
    render
    expect(rendered).to have_tag 'div', with: { class: 'explanation' } do
      with_text(/#{explanation_field.prompt}/)
    end
  end

  it 'gives a label to date/time fields' do
    date_time_field = create :field, form: @form, data_type: 'date/time'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{date_time_field.prompt}/)
      end
    end
  end

  it 'gives date/time fields a class of datetimepicker' do
    create :field, form: @form, data_type: 'date/time'
    render
    expect(rendered).to have_tag 'input', with: { class: 'datetimepicker' }
  end

  it 'gives a label to date fields' do
    date_field = create :field, form: @form, data_type: 'date'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{date_field.prompt}/)
      end
    end
  end

  it 'gives date fields a class of datepicker' do
    create :field, form: @form, data_type: 'date'
    render
    expect(rendered).to have_tag 'input', with: { class: 'datepicker' }
  end

  it 'gives a label to text fields' do
    text_field = create :field, form: @form, data_type: 'text'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{text_field.prompt}/)
      end
    end
  end

  it 'makes a text field from a field of type text' do
    create :field, form: @form, data_type: 'text'
    render
    expect(rendered).to have_tag 'input', with: { type: 'text' }
  end

  it 'gives a label to time fields' do
    time_field = create :field, form: @form, data_type: 'time'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{time_field.prompt}/)
      end
    end
  end

  it 'gives time fields a class of timepicker' do
    create :field, form: @form, data_type: 'time'
    render
    expect(rendered).to have_tag 'input', with: { class: 'timepicker' }
  end

  it 'gives a label to long-text fields' do
    long_text_field = create :field, form: @form, data_type: 'long-text'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{long_text_field.prompt}/)
      end
    end
  end

  it 'gives an input box for a long-text field' do
    create :field, form: @form, data_type: 'long-text'
    render
    expect(rendered).to have_tag 'textarea'
  end

  it 'gives a label to number fields' do
    number_field = create :field, form: @form, data_type: 'number'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text(/#{number_field.prompt}/)
      end
    end
  end

  it 'makes an input for number fields' do
    create :field, form: @form, data_type: 'number'
    render
    expect(rendered).to have_tag 'input'
  end

  it 'gives a label to yes/no fields' do
    yes_no_field = create :field, form: @form, data_type: 'yes/no'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text yes_no_field.prompt
      end
    end
  end

  it 'makes a radio button for yes/no fields' do
    create :field, form: @form, data_type: 'yes/no'
    render
    expect(rendered).to have_tag 'input', with: { type: 'radio' }
  end

  it 'gives a label to option fields' do
    option_field = create :field, form: @form, data_type: 'options'
    render
    expect(rendered).to have_tag 'div', with: { class: 'label' } do
      with_tag 'label' do
        with_text option_field.prompt
      end
    end
  end

  it 'makes selectable options for option fields' do
    create :field, form: @form, data_type: 'options', options: %w[car]
    render
    expect(rendered).to have_tag 'select' do
      with_tag 'option', with: { value: 'car' }
    end
  end

  it 'puts an asterisk next to required fields' do
    create :field, form: @form, required: true
    render
    expect(rendered).to have_tag 'span', with: { class: 'ast' }
  end

  it 'has a form submitting to the submit form path' do
    render
    expect(rendered).to have_form main_form_path, :post
  end

  context 'submit is true' do
    before do
      assign :submit, true
    end

    it 'has an enabled submit button' do
      render
      expect(rendered).to have_form main_form_path, :post do
        without_tag 'input', with: { type: 'submit', disabled: true }
      end
    end
  end

  context 'submit is false' do
    before do
      assign :submit, false
    end

    it 'has a disabled submit button' do
      render
      expect(rendered).to have_form main_form_path, :post do
        with_tag 'input', with: { type: 'submit', disabled: 'disabled' }
      end
    end
  end

  context 'current user is present' do
    before do
      @user = create :user
      when_current_user_is @user
    end

    it 'fills in the user fields' do
      render
      expect(rendered).to have_form main_form_path, :post do
        with_text_field 'user[first_name]', @user.first_name
        with_text_field 'user[last_name]',  @user.last_name
        with_text_field 'user[email]',      @user.email
      end
    end
  end

  context 'current user is not present' do
    it 'does not fill in the user fields' do
      render
      expect(rendered).to have_form main_form_path, :post do
        with_text_field 'user[first_name]', nil
        with_text_field 'user[last_name]',  nil
        with_text_field 'user[email]',      nil
      end
    end
  end
end
