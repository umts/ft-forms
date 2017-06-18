# frozen_string_literal: true

class FormsController < ApplicationController
  # Whitelist actions below for non-staff access.
  skip_before_action :access_control, only: %i[show submit thank_you]
  # Since these actions are used to edit forms, maintain the form in session.
  before_action :find_form, only: %i[submit thank_you update destroy]
  before_action :placeholder_from_shibboleth_attributes, only: %i[show]
  before_action :form_params, only: %i[create update]

  def index
    @forms = Form.live.includes(:draft)
  end

  def show
    @form = Form.friendly.find(params[:id])
    @submit = true unless params[:no_submit]
  end

  def edit
    @form = Form.friendly.find(params[:id])
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
    FtFormsMailer.send_form(@form, data, user).deliver_now
    FtFormsMailer.send_confirmation(user, data, params[:reply_to]).deliver_now
    redirect_to thank_you_form_url(@form.friendly_id)
  end

  def new
    @form = Form.new
    @form.fields << @form.new_field
  end

  def create
    form = Form.new form_params.except(:fields_attributes)
    fields_attributes = form_params[:fields_attributes]
    binding.pry
    if form.save
      unless form_params[:fields_attributes]['0'][:prompt].blank?
      end
      form.update_fields fields_attributes
      render :show
    else
      render :edit
    end
  end

  def destroy
    @form.destroy
    redirect_to forms_url
    flash[:message] = 'Form successfully deleted.'
  end

  def update
    @form.update form_params.except(:fields_attributes)
    @form.update_fields form_params[:fields_attributes]
    @form.reload # since fields have been updated
    if @form.save
      flash[:message] = 'Form successfully updated'
      render :show
    else
      flash[:error] = 'Something went wrong'
      render :edit
    end
  end

  private

  def create_user
    user_attributes = params.require(:user).permit(:first_name,
                                                   :last_name,
                                                   :email)
    user_attributes[:spire] = session[:spire]
    user_attributes[:staff] = false
    user = User.create(user_attributes)
    session[:user_id] = user.id
    set_current_user
    user
  end

  def find_form
    @form = Form.friendly.find(params.require :id)
  end

  def placeholder_from_shibboleth_attributes
    @placeholder = User.new(email: request.env['mail'],
                            first_name: request.env['givenName'],
                            last_name: request.env['surName'])
  end

  def form_params
    params.require(:form).permit(:name,
                                 :email,
                                 :reply_to,
                                 fields_attributes: %i[number
                                                       prompt
                                                       data_type
                                                       required
                                                       id])
  end
end
