class ApplicationController < ActionController::Base
  attr_accessor :current_user
  protect_from_forgery with: :exception
  before_action :set_spire
  before_action :set_current_user
  before_action :redirect_unauthenticated
  before_action :access_control
  before_action :set_shibboleth_attributes
  layout 'application'

  private

  # '... and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def access_control
    deny_access and return unless @current_user.present? && @current_user.staff?
  end
  # rubocop:enable Style/AndOr

  def deny_access
    if request.xhr?
      render nothing: true, status: :unauthorized
    else
      render file: 'public/401.html',
             status: :unauthorized,
             layout: false
    end
  end

  # '... and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def redirect_unauthenticated
    unless @current_user.present? || session.key?(:spire)
      logger.info 'Request:'
      logger.info request.inspect
      logger.info 'Session:'
      logger.info session.inspect
      redirect_to unauthenticated_session_path and return
    end
  end
  # rubocop:enable Style/AndOr

  def set_current_user
    @current_user =
      if session.key? :user_id
        User.find_by id: session[:user_id]
      elsif session.key? :spire
        User.find_by spire: session[:spire]
      end
  end

  def set_spire
    session[:spire] = request.env['fcIdNumber'] if request.env.key? 'fcIdNumber'
  end

  def set_shibboleth_attributes
    [:mail, :first_name, :last_name].each do |attribute|
      if request.env.key? attribute.to_s # request.env keys are strings
        session[attribute] = request.env[attribute.to_s]
      end
    end
  end

  # '... and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def show_errors(object, redirect_path = :back)
    flash[:errors] = object.errors.full_messages
    redirect_to redirect_path and return
  end
  # rubocop:enable Style/AndOr
end
