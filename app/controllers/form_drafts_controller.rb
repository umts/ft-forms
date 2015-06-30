class FormDraftsController < ActionController::Base
  before_action :find_form_draft, except: :new

  def edit
    @draft.fields << @draft.new_field
  end

  def new
    form = Form.find(params.require :form_id)
    draft = form.create_draft @current_user
    redirect_to edit_form_draft_path(draft)
  end

  def show
  end

  def update
    @draft.update_attributes params.require(:form_draft).permit!
    case params.require :commit
    when 'Save changes and continue editing'
      redirect_to edit_form_draft_path(@draft)
    when 'Preview changes'
      render 'show'
    end
  end

  private

  def find_form_draft
    @draft = FormDraft.find(params.require :form_draft_id)
  end
end
