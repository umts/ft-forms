class SessionsController < ApplicationController
  layout false
  skip_before_action :access_control, :set_current_user, :set_spire

  def destroy
    if Rails.env.production?
      redirect_to '/Shibboleth.sso/Logout?return=https://webauth.oit.umass.edu/Logout'
    else redirect_to dev_login_sessions_url
    end
    session.clear
  end

  # '... and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def dev_login
    if Rails.env.production?
      redirect_to new_session_path and return
    else
      if request.get?
        @staff     = User.staff
        @not_staff = User.not_staff
        @new_spire = (User.pluck(:spire).map(&:to_i).last + 1).to_s.rjust 8, '0'
      elsif request.post?
        assign_user
        redirect_to meet_and_greet_forms_url
      end
    end
  end
  # rubocop:enable Style/AndOr

  # '... and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def new
    redirect_to dev_login_sessions_path and return unless Rails.env.production?
    # TODO: decide on what it should do in production
  end
  # rubocop:enable Style/AndOr

  private

  def assign_user
    if params.permit(:user_id).present?
      @user = User.find_by(id: params[:user_id])
      session[:user_id] = @user.id
    elsif params.permit(:spire).present?
      session[:spire] = params[:spire]
    end
  end
end
