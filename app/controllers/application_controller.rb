# frozen_string_literal: true

class ApplicationController < ActionController::Base
  attr_accessor :current_user

  before_action :set_spire
  before_action :set_current_user
  before_action :redirect_unauthenticated
  before_action :access_control

  layout 'application'

  private

  def access_control
    deny_access and return unless @current_user.present? && @current_user.staff?
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

  def redirect_unauthenticated
    return if @current_user.present? || session.key?(:spire)

    redirect_to unauthenticated_session_path
  end

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
end
