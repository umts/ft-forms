# frozen_string_literal: true

class SessionsController < ApplicationController
  layout false
  skip_before_action :redirect_unauthenticated, :access_control

  def destroy
    session.clear
    if Rails.env.production?
      redirect_to '/Shibboleth.sso/Logout?return=https://webauth.umass.edu/Logout'
    else redirect_to dev_login_url
    end
  end

  # route not defined in production
  def dev_login
    if request.get?
      @staff     = User.staff
      @not_staff = User.not_staff
      @new_spire = new_spire
    elsif request.post?
      assign_user
      redirect_to forms_url
    end
  end

  private

  def assign_user
    if params.permit(:user_id).present?
      @user = User.find_by(id: params[:user_id])
      session[:user_id] = @user.id
    elsif params.permit(:spire).present?
      session[:spire] = params[:spire]
    end
  end

  def new_spire
    format('%08d@umass.edu', User.maximum(:spire).to_i + 1)
  end
end
