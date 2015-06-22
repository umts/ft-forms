class FormsController < ApplicationController
  def edit
    @form = Form.find(params.require :id)
  end

  def index
    @forms = Form.all
  end

  def meet_and_greet
    @form = Form.find_by name: 'Meet & Greet Request Form'
    render 'show'
  end

  def preview
    @form = Form.includes(:fields).where(id: params.require(:id)).first
    @form_changes = params.require(:form).permit!
    # form_changes = params.require(:form).permit :name
    @form.assign_attributes @form_changes
    @preview = true
    render 'show'
  end

  def show
    @form = Form.find(params.require :id)
  end

  # We're implementing this later, disable warnings.
  # rubocop:disable Style/EmptyElse
  # rubocop:disable Style/GuardClause
  def submit
    responses = params.require :responses
    if FtFormsMailer.send_form responses
      FtFormsMailer.send_confirmation responses
      redirect_to thank_you_form_url
    else
      # TODO
    end
  end
  # rubocop:enable Style/EmptyElse
  # rubocop:enable Style/GuardClause

  def thank_you
    @form = Form.find(params.require :id)
  end

  def update
    @form = Form.includes(:fields).where(id: params.require(:id)).first
    @form_changes = params.require(:form).permit!
    # form_changes = params.require(:form).permit :name
    @form.update @form_changes
    redirect_to forms_url
  end
end
