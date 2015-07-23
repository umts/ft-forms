require 'rails_helper'
include RSpecHtmlMatchers

describe 'forms/show.haml' do
  before :each do
    @form = create :form
    assign :form, @form
  end
  let :main_form_path do
    submit_form_path @form
  end
  it 'has a form submitting to the submit form path' do
    render
    expect(rendered).to have_form main_form_path, :post
  end
  context 'submit is true' do
    before :each do
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
    before :each do
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
    before :each do
      @user = create :user
      when_current_user_is @user, view: true
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
