require 'rails_helper'
include RSpecHtmlMatchers

describe 'form_drafts/show.haml' do
  before :each do
    @email = 'draft.email@test.host'
    @draft = create :form_draft, email: @email
    assign :draft, @draft
  end
  let :main_form_path do
    submit_form_path @draft.form
  end
  it 'has a form preview message including the email value of the draft' do
    render
    expect(rendered).to have_tag '#form_preview_message' do
      with_text(/is not live/)
      with_text(/#{@email}/)
    end
  end
  it 'has a form submitting to submit form path, but with disabled submit' do
    render
    expect(rendered).to have_form main_form_path, :post do
      with_tag 'input', with: { type: 'submit', disabled: 'disabled' }
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
  it 'has a button to continue editing the draft' do
    render
    action_path = edit_form_draft_url @draft
    expect(rendered).to have_form action_path, :get do
      with_submit 'Continue editing'
    end
  end
  it 'has a button to discard the changes' do
    render
    action_path = form_draft_path @draft
    expect(rendered).to have_form action_path, :post do
      with_submit 'Discard changes'
      with_hidden_field '_method', :delete
    end
  end
  it 'has a button to save the form' do
    render
    action_path = update_form_form_draft_url @draft
    expect(rendered).to have_form action_path, :post do
      with_submit 'Save form'
    end
  end
end
