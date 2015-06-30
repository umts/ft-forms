class FormsController < ApplicationController
  # Whitelist actions below for non-staff access.
  skip_before_action :access_control, only: [:meet_and_greet,
                                             :show,
                                             :submit,
                                             :thank_you]
  # Since these actions are used to edit forms, maintain the form in session.
  before_action :find_form, only: [:show, :submit, :thank_you, :update]

  def index
    @forms = Form.includes :form_drafts
  end

  def meet_and_greet
    @form = Form.find_by name: 'Meet & Greet Request Form'
    @submit = true
    render 'show'
  end

  def show
    @submit = true unless params[:no_submit]
  end

  def submit
    responses = params.require :responses
    FtFormsMailer.send_form responses
    FtFormsMailer.send_confirmation responses
    redirect_to thank_you_form_url
  end

  def thank_you
  end

  def update
    @form_changes = params.require(:form).permit!
    if @form.update @form_changes
      session.delete :forms
      flash[:message] = 'Form has been updated.'
      redirect_to forms_url
    else show_errors @form
    end
  end

  private

  def find_form
    @form = Form.find(params.require :id)
  end
end
