# frozen_string_literal: true

require 'rails_helper'

describe 'form_drafts/edit.haml' do

  before :each do
    @draft = create :form_draft
    @top_field    = create :field, data_type: 'text', form_draft: @draft
    @field        = create :field, data_type: 'text', form_draft: @draft
    @bottom_field = create :field, data_type: 'text', form_draft: @draft
  end
  it 'contains the name of the form draft' do
    render
    expect(rendered).to have_tag 'h1', with: { class: 'title' } do
      with_text(/#{@draft.form.name}/)
    end
  end
  it 'has a form to edit the form draft' do
    render
    action_path = form_draft_path @draft
    expect(rendered).to have_form action_path, :post do
      with_text_field 'form_draft[name]'
      with_text_field 'form_draft[email]'
    end
  end
  it 'has inputs for each field' do
    render
    expect(rendered).to have_tag 'input' do
      (0...@draft.fields.count).each do |index|
        base_tag_name = "form_draft[fields_attributes][#{index}]"
        with_hidden_field "#{base_tag_name}[number]"
        with_text_field "#{base_tag_name}[placeholder]"
        with_checkbox "#{base_tag_name}[required]"
      end
    end
    expect(rendered).to have_tag 'textarea' do
      (0...@draft.fields.count).each do |index|
        base_tag_name = "form_draft[fields_attributes][#{index}]"
        with_text_area "#{base_tag_name}[prompt]"
      end
    end
    expect(rendered).to have_tag 'select' do
      (0...@draft.fields.count).each do |index|
        base_tag_name = "form_draft[fields_attributes][#{index}]"
        with_select "#{base_tag_name}[data_type]"
      end
    end
  end
  context 'input data type is options' do
    before :each do
      @field.update data_type: 'options', options: %w[car van]
    end
    it 'lists the current options' do
      render
      expect(rendered).to have_tag 'li', text: 'car'
      expect(rendered).to have_tag 'li', text: 'van'
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
  context 'field is a heading or an explanation' do
    before :each do
      @heading = create :field, form_draft: @draft, data_type: 'heading'
      @explanation = create :field, form_draft: @draft, data_type: 'explanation'
    end
    it 'does not include the placeholder field' do
      render
      heading_index = @draft.fields.index @heading
      expect(rendered).not_to have_tag 'input', with: {
        name: "form_draft[fields_attributes][#{heading_index}][placeholder]"
      }
      expl_index = @draft.fields.index @explanation
      expect(rendered).not_to have_tag 'input', with: {
        name: "form_draft[fields_attributes][#{expl_index}][placeholder]"
      }
    end
  end
end
