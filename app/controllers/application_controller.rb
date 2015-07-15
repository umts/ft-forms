class ApplicationController < ActionController::Base
  attr_accessor :current_user
  protect_from_forgery with: :exception
  before_action :set_current_user
  before_action :set_spire, if: -> { @current_user.blank? }
  before_action :access_control
  layout 'application'

  private

  # '... and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def access_control
    redirect_to new_session_path and return if @current_user.blank?
    deny_access and return unless @current_user.staff?
  end
  # rubocop:enable Style/AndOr

  def current_user_exists?
    session.key?(:user_id) && User.find_by(id: session[:user_id]).present?
  end

  def deny_access
    if request.xhr?
      render nothing: true, status: :unauthorized
    else
      render file: 'public/401.html',
             status: :unauthorized,
             layout: false
    end
  end

  def set_current_user
    @current_user = User.find session[:user_id] if current_user_exists?
  end

  # '... and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def set_spire
    if spire_exists?
      session[:spire] ||= request.env['SPIRE_ID']
    else redirect_to unauthenticated_session_path and return
      # something has gone terribly, awfully wrong
    end
  end
  # rubocop:enable Style/AndOr

  def spire_exists?
    session.key?(:spire) || request.env.key?('SPIRE_ID')
  end

  # '... and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def show_errors(object, redirect_path = :back)
    flash[:errors] = object.errors.full_messages
    redirect_to redirect_path and return
  end
  # rubocop:enable Style/AndOr
end
