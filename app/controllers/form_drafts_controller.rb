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
    @draft.fields << @draft.new_field unless @draft.fields.present?
  end

  def new
    form = Form.find_by(id: params[:form_id]) || Form.new
    if form.persisted?
      draft = form.find_or_create_draft @current_user
      redirect_to edit_form_draft_path(draft) and return
    end
    @draft = FormDraft.new user: @current_user
    # make sure draft has the form
    @draft.fields << @draft.new_field
  end

  def create
    @draft = FormDraft.new draft_params
    if @draft.save
      redirect_to action: 'show', id: @draft.id
    else
      flash[:errors] = @draft.errors.full_messages
      render 'new'
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
    params.require(:form_draft)
                          .permit(:name,
                                  :email,
                                  :reply_to,
                                  fields_attributes: %i[number
                                                        prompt
                                                        placeholder
                                                        data_type
                                                        required
                                                        options])
  end

  def find_form_draft
    @draft = FormDraft.includes(:fields).find(params.require :id)
  end
end
