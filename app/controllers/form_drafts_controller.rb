# frozen_string_literal: true

class FormDraftsController < ApplicationController
  before_action :find_form_draft, except: %i[create new]
  before_action :draft_params, only: %i[create update]

  def destroy
    @draft.destroy
    flash[:message] = 'Draft has been discarded.'
    redirect_to forms_url
  end

  def edit
    @draft.fields << @draft.new_field
  end

  def new
    form = Form.find(params.require :form_id)
    @draft = form.create_draft @current_user
    redirect_to edit_form_draft_path(@draft)
  end

  def move_field
    field_number = params.require(:number).to_i
    direction = params.require(:direction).to_sym
    @draft.move_field field_number, direction
    redirect_to edit_form_draft_path
  end

  def remove_field
    field_number = params.require(:number).to_i
    @draft.remove_field field_number
    redirect_to edit_form_draft_path
  end

  def create
    form_params = @draft_params.except(:fields_attributes)
    form = Form.create! form_params
    @draft = form.create_draft(@current_user)
    @draft.update_fields @draft_params[:fields_attributes]
    case params.require :commit
    when 'Save changes and continue editing'
      redirect_to edit_form_draft_path(@draft)
    when 'Preview changes'
      render 'show'
    end
  end

  def update
    @draft.fields.delete_all
    if @draft.update_attributes @draft_params
      redirect_to action: 'show'
    else
      flash[:errors] = @draft.errors.full_messages
      render 'edit'
    end
  end

  def update_form
    @draft.update_form!
    flash[:message] = 'Form has been updated and is now live. ' \
                      'Draft has been discarded.'
    redirect_to forms_url
  end

  private

  def draft_params
    @draft_params = params.require(:form_draft)
                          .permit(:name,
                                  :email,
                                  :reply_to,
                                  fields_attributes: %i[number
                                                        prompt
                                                        data_type
                                                        required
                                                        options])
    @draft_params[:fields_attributes].reject! do |_i, attributes| 
      attributes[:prompt].blank?
    end
    @draft_params[:fields_attributes].each do |index, attributes|
      attributes[:number] = (index.to_i + 1)
      if attributes[:options].present?
        attributes[:options] = attributes[:options].gsub(/\s+/, "").split(',')
      end
    end
  end

  def find_form_draft
    @draft = FormDraft.includes(:fields).find(params.require :id)
  end
end
