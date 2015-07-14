require 'rails_helper'
include RSpecHtmlMatchers

describe 'form_drafts/edit.haml' do
  before :each do
    @draft = create :form_draft
    @top_field = create :field, form_draft: @draft
    @field = create :field, form_draft: @draft
    @bottom_field = create :field, form_draft: @draft
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
  it 'has inputs for each field' do
    render
    expect(rendered).to have_tag 'tr' do
      with_hidden_field 'form_draft[fields_attributes][0][number]'
      with_text_area 'form_draft[fields_attributes][0][prompt]'
      with_select 'form_draft[fields_attributes][0][data_type]'
      with_checkbox 'form_draft[fields_attributes][0][required]'
    end
  end
  context 'input data type is options' do
    before :each do
      @field.update data_type: 'options', options: %w(car van)
    end
    it 'lists the current options' do
      render
      expect(rendered).to have_tag 'li'
    end
    it 'allows editing of options' do
      render
      action_path = edit_field_path @field
      expect(rendered).to have_tag 'a', with: { href: action_path }
    end
  end
  it 'has a button to remove each field' do
    render
    action_path = remove_field_form_draft_path(@draft, number: @field.number)
    expect(rendered).to have_form action_path, :post
  end
  it 'has a button to move down when top field' do
    render
    action_path = move_field_form_draft_path(@draft,
                                             number: @top_field.number,
                                             direction: :down)
    expect(rendered).to have_form action_path, :post
  end
  it 'does not have a button to move up when top field' do
    render
    action_path = move_field_form_draft_path(@draft,
                                             number: @top_field.number,
                                             direction: :up)
    expect(rendered).not_to have_form action_path, :post
  end
  it 'has a button to move up when bottom field' do
    render
    action_path = move_field_form_draft_path(@draft,
                                             number: @bottom_field.number,
                                             direction: :up)
    expect(rendered).to have_form action_path, :post
  end
  it 'does not have a button to move down when bottom field' do
    render
    action_path = move_field_form_draft_path(@draft,
                                             number: @bottom_field.number,
                                             direction: :down)
    expect(rendered).not_to have_form action_path, :post
  end
  it 'has both a button to move up and move down when middle button' do
    render
    up_path = move_field_form_draft_path(@draft,
                                         number: @field.number,
                                         direction: :up)
    down_path = move_field_form_draft_path(@draft,
                                           number: @field.number,
                                           direction: :down)
    expect(rendered).to have_form up_path, :post
    expect(rendered).to have_form down_path, :post
  end
  context 'field is a new record' do
    before :each do
      @new_field = @draft.new_field
      @draft.fields << @new_field
    end
    it 'has no button to move up, down, or remove' do
      render
      up_path = move_field_form_draft_path(@draft,
                                           number: @new_field.number,
                                           direction: :up)
      down_path = move_field_form_draft_path(@draft,
                                             number: @new_field.number,
                                             direction: :down)
      remove_path = remove_field_form_draft_path(@draft,
                                                 number: @new_field.number)
      expect(rendered).not_to have_form remove_path, :post
      expect(rendered).not_to have_form up_path, :post
      expect(rendered).not_to have_form down_path, :post
    end
  end
end
