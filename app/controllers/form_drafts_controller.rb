# frozen_string_literal: true

class FormDraftsController < ApplicationController
  before_action :find_form_draft, except: %i[create new]
  before_action :draft_params, only: %i[create update]

  def destroy
    @draft.destroy
    flash[:message] = 'Draft has been discarded.'
    redirect_to forms_url
  end

  def edit; end

  def new
    form = Form.find_by(id: params[:form_id]) || Form.new
    if form.persisted?
      @draft = form.create_draft @current_user
    else
      @draft = FormDraft.new user: @current_user
    end
    @draft.fields << @draft.new_field
  end

  def create
    # the draft must have an ID before its fields are created in order to not
    # violate uniqueness constraints for number (see Field model)
    @draft = FormDraft.create @draft_params.except(:fields_attributes)
    @draft.update @draft_params
    if @draft.valid?
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
    @draft_params = params.require(:form_draft)
                          .permit(:name,
                                  :email,
                                  :reply_to,
                                  fields_attributes: %i[number
                                                        prompt
                                                        placeholder
                                                        data_type
                                                        required
                                                        options])
    if @draft_params[:fields_attributes].present?
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
  end

  def find_form_draft
    @draft = FormDraft.includes(:fields).find(params.require :id)
  end
end
