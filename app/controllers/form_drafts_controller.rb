class FormDraftsController < ApplicationController
  before_action :find_form_draft, except: :new

  def edit
    @draft.fields << @draft.new_field
  end

  def new
    form = Form.find(params.require :form_id)
    if params.key?(:discard) && form.draft_belonging_to?(@current_user)
      form.draft_belonging_to(@current_user).destroy
    end
    @draft = form.create_draft @current_user
    redirect_to edit_form_draft_path(@draft)
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

  private

  def find_form_draft
    @draft = FormDraft.find(params.require :id)
  end
end
