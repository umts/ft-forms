# frozen_string_literal: true

class FormDraftsController < ApplicationController
  before_action :find_form_draft, except: %i[create new]

  def destroy
    @draft.destroy
    flash[:message] = 'Draft has been discarded.'
    redirect_to forms_url
  end

  def edit
    @draft = FormDraft.find params[:id]
    @draft.fields << @draft.new_field if @draft.fields.blank?
  end

  def new
    form = Form.find_by(id: params[:form_id]) || Form.new
    if form.persisted?
      @draft = form.find_or_create_draft @current_user
      redirect_to edit_form_draft_path(@draft) and return
    end
    @draft = FormDraft.new
    @draft.fields << @draft.new_field
  end

  def create
    @draft = FormDraft.new draft_params.merge(user: @current_user)
    if @draft.save
      redirect_to action: 'show', id: @draft.id
    else
      flash.now[:errors] = @draft.errors.full_messages
      render 'new'
    end
  end

  def update
    # avoid any number uniqueness violation.
    @draft.fields.destroy_all
    @draft.assign_attributes draft_params
    if @draft.save
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
    params.require(:form_draft).permit(:name, :email, :reply_to).tap do |p|
      p[:fields_attributes] = fields_params if fields_params.present?
    end
  end

  def fields_params
    attrs = %i[number prompt placeholder data_type required options]
    fields = params.require(:form_draft)
                   .permit(fields_attributes: attrs)[:fields_attributes]
    return if fields.blank?

    fields.transform_values do |field|
      field[:options] = field[:options].split(/\W+/) if field[:options].present?
      field
    end
  end

  def find_form_draft
    @draft = FormDraft.includes(:fields).find(params.require(:id))
  end
end
