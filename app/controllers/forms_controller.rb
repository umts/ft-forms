class FormsController < ApplicationController
  # Whitelist actions below for non-staff access.
  skip_before_action :access_control, only: [:meet_and_greet,
                                             :show,
                                             :submit,
                                             :thank_you]
  # Since these actions are used to edit forms, maintain the form in session.
  before_action :find_form, except: [:clear_edits,
                                     :index,
                                     :meet_and_greet,
                                     :submit]
  def clear_edits
    session.delete :forms
    redirect_to forms_path
  end

  def edit
    @form = stored_form
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
    stored_form.assign_attributes(params.require(:form).permit!)
    @form = stored_form
    case params.require :commit
    when 'Save changes and continue editing'
      render 'edit'
    when 'Preview changes'
      @preview = true
      render 'show'
    end
  end

  def remove_field
    field = stored_form.fields.where number: params.require(:number)
    stored_form.fields -= field
    @form = stored_form
    render 'edit'
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

  def stored_form
    session[:forms] ||= {}
    session[:forms][@form.id] ||= @form
    session[:forms][@form.id]
  end
end
