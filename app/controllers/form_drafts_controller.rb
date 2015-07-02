class FormDraftsController < ApplicationController
  before_action :find_form_draft, except: :new

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

  def show
  end

  def update
    @draft.update params.require(:form_draft).permit!
    case params.require :commit
    when 'Save changes and continue editing'
      redirect_to edit_form_draft_path(@draft)
    when 'Preview changes'
      render 'show'
    end
  end

  def update_form
    @draft.update_form!
    flash[:message] = 'Form has been updated and is now live. ' \
                      'Draft has been discarded.'
    redirect_to forms_url
  end

  private

  def find_form_draft
    @draft = FormDraft.includes(:fields).find(params.require :id)
  end
end
