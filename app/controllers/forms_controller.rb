# frozen_string_literal: true

class FormsController < ApplicationController
  # Whitelist actions below for non-staff access.
  skip_before_action :access_control, only: %i[show submit thank_you]
  # Since these actions are used to edit forms, maintain the form in session.
  before_action :find_form, only: %i[submit thank_you destroy]

  def index
    @forms = Form.includes :drafts
    @drafts = @current_user.form_drafts.where form_id: nil
  end

  def show
    @placeholder = User.new(email: request.env['mail'],
                            first_name: request.env['givenName'],
                            last_name: request.env['surName'])
    @form = Form.friendly.find(params[:id])
    @submit = true unless params[:no_submit]
  end

  def submit
    update_user
    user = @current_user || create_user
    data = params.require :responses
    FtFormsMailer.send_form(@form, data, user).deliver_now
    FtFormsMailer.send_confirmation(user, data, params[:reply_to]).deliver_now
    redirect_to thank_you_form_url(@form.friendly_id)
  end

  def destroy
    @form.destroy
    redirect_to forms_url
    flash[:message] = 'Form successfully deleted.'
  end

  def thank_you; end

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
    @form = Form.friendly.find(params.require(:id))
  end

  def update_user
    return if @current_user.blank?

    @current_user.update(params.require(:user).permit(:first_name, :last_name, :email))
  end
end
