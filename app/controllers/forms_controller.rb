class FormsController < ApplicationController
  # WHITELISTED ACTIONS
  skip_before_action :access_control, only: [:meet_and_greet,
                                             :show,
                                             :submit,
                                             :thank_you]
  before_action :find_form, except: [:index, :meet_and_greet, :submit]

  def edit
  end

  def index
    @forms = Form.all
  end

  def meet_and_greet
    @form = Form.find_by name: 'Meet & Greet Request Form'
    @submit = true
    render 'show'
  end

  def preview
    @form_changes = params.require(:form).permit!
    # form_changes = params.require(:form).permit :name
    @form.assign_attributes @form_changes
    @preview = true
    flash[:message] = 'You are previewing your changes. This form, as shown here, is not live.'
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
    # form_changes = params.require(:form).permit :name
    if @form.update @form_changes
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
