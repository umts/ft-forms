class SessionsController < ApplicationController
  layout false
  skip_before_action :access_control, :set_current_user, :set_spire

  def destroy
    session.clear
    if Rails.env.production?
      redirect_to '/Shibboleth.sso/Logout?return=https://webauth.oit.umass.edu/Logout'
    else redirect_to dev_login_url
    end
  end

  # '... and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def dev_login
    deny_access and return if Rails.env.production?
    if request.get?
      @staff     = User.staff
      @not_staff = User.not_staff
      @new_spire = new_spire
    elsif request.post?
      assign_user
      redirect_to meet_and_greet_forms_url
    end
  end
  # rubocop:enable Style/AndOr

  # Only shows if no user in database AND no SPIRE provided from Shibboleth
  def unauthenticated
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
    (User.pluck(:spire).map(&:to_i).last + 1).to_s.rjust 8, '0'
  end
end
