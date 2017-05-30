require 'rails_helper'
include RSpecHtmlMatchers

describe 'forms/index.haml' do
  before :each do
    @staff_member = create :user, :staff
    when_current_user_is @staff_member, view: true
    @form = create :form
    assign :forms, Array(@form)
  end
  it 'has an h1 title of Forms' do
    render
    expect(rendered).to have_tag 'h1.title' do
      with_text 'Forms'
    end
  end
  it 'has a forms table' do
    render
    expect(rendered).to have_tag 'table#forms_table'
  end
  it 'has a td with a link to the form, with no_submit true' do
    action_path = form_url(@form, no_submit: true)
    render
    expect(rendered).to have_tag 'table#forms_table td' do
      with_tag 'a', with: { href: action_path }
    end
  end
  context 'current user does not have a draft for the form' do
    it 'has a link called Edit which makes a new form draft' do
      action_path = new_form_draft_path(form_id: @form.id)
      render
      expect(rendered).to have_tag 'table#forms_table td' do
        with_tag 'a', with: { href: action_path } do
          with_text 'Edit'
        end
      end
    end
  end
  context 'current user has a draft for the form' do
    before :each do
      @draft = create :form_draft, form: @form, user: @staff_member
    end
    it 'has a link to resume editing the draft' do
      action_path = edit_form_draft_path(@draft)
      render
      expect(rendered).to have_tag 'table#forms_table td' do
        with_tag 'a', with: { href: action_path } do
          with_text 'Resume editing saved draft'
        end
      end
    end
    it 'has a button to discard the draft' do
      action_path = form_draft_path(@draft)
      render
      expect(rendered).to have_tag 'table#forms_table td' do
        with_tag 'form', with: { action: action_path } do
          with_hidden_field '_method', 'delete'
          with_submit 'Discard saved draft'
        end
      end
    end
  end
  it 'has a link for a new form' do
    render
    expect(rendered).to have_tag 'a', with: { href: new_form_path } do
      with_text 'New form'
    end
  end
end
