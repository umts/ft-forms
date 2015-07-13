require 'rails_helper'
include RSpecHtmlMatchers

describe 'form_drafts/edit.haml' do
  before :each do
    @draft = create :form_draft
  end
  it 'contains the name of the form draft' do
    render
    expect(rendered).to have_tag 'h1', with: { class: 'title' }
  end
  it 'has a form to edit the form draft' do
    render
    action_path = form_draft_path @draft
    expect(rendered).to have_form action_path, :post
  end
end
