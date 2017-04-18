class FormsController < ApplicationController
  # Whitelist actions below for non-staff access.
  skip_before_action :access_control, only: [:show,
                                             :submit,
                                             :thank_you]
  # Since these actions are used to edit forms, maintain the form in session.
  before_action :find_form, only: [:submit, :thank_you, :update]
  before_action :placeholder_from_shibboleth_attributes, only: [:show]

  def index
    @forms = Form.includes :drafts
  end

  def meet_and_greet
    @form = Form.friendly.find(name: 'Meet & Greet Request Form')
    @submit = true
    render 'show'
  end

  def show
    @form = Form.friendly.find(params[:id])
    @submit = true unless params[:no_submit]
  end

  def submit
    if @current_user.present?
      @current_user.update_attributes(
        params.require(:user)
        .permit(:first_name, :last_name, :email)
      )
    end
    user = @current_user || create_user
    data = params.require :responses
    FtFormsMailer.send_form(@form, data).deliver_now
    FtFormsMailer.send_confirmation(user, data, params[:reply_to]).deliver_now
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

  def create_user
    user_attributes = params.require(:user).permit!
    user_attributes[:spire] = session[:spire]
    user_attributes[:staff] = false
    user = User.create(user_attributes)
    session[:user_id] = user.id
    set_current_user
    user
  end

  def find_form
    @form = Form.find(params.require :id)
  end

  def placeholder_from_shibboleth_attributes
    @placeholder = User.new(email: request.env['mail'],
                            first_name: request.env['givenName'],
                            last_name: request.env['surName'])
  end
end
