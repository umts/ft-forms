# frozen_string_literal: true

class FormDraftsController < ApplicationController
  before_action :find_form_draft, except: %i[create new]
  before_action :draft_params, only: %[create update]

  def create
    draft_params = params.require(:form_draft)
      .permit(
        :name,
        :email,
        :reply_to,
        fields: %[number prompt data_type required placeholder]
    )
    binding.pry
    form_params = draft_params.except(:fields)
    form = Form.create! form_params
    @draft = form.create_draft
    field_attributes = draft_params[:fields]
    draft.update_fields(field_attributes)
    if draft.save
      redirect_to 'show'
    else
      flash[:errors] = draft.errors.full_messages
      redirect_to new_form_path
    end
  end

  def update
    @draft.update @draft_params.except(:fields)
    @draft.update_fields @draf_params[:fields]
    @draft.reload
    render 'show'
  end

  def destroy
    @draft.destroy
    flash[:message] = 'Draft has been discarded'
    redirect_to forms_url
  end

  def edit
    @draft.fields << @draft.new_field if @draft.fields.empty?
  end

  def show
    @draft = FormDraft.find(params[:id])
  end

  def new
    form = Form.find(params.require :form_id)
    @draft = form.create_draft
    redirect_to edit_form_draft_path(@draft)
  end

  def update_form
  end

  private

  def draft_params
    binding.pry
    @draft_params = params.require(:form_draft)
      .permit(
        :name,
        :email,
        :reply_to,
        fields: %[number prompt data_type required placeholder]
    )
  end

  def find_form_draft
    @draft = FormDraft.includes(:fields).find(params.require :id)
  end

end
