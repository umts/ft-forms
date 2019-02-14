# frozen_string_literal: true

require 'factory_bot_rails'
require 'simplecov'
require 'umts-custom-matchers'

SimpleCov.start 'rails' do
  refuse_coverage_drop
end

# Sets current user based on two acceptable values:
# 1. a symbol name of a user factory trait;
# 2. a specific instance of User.
def when_current_user_is(user, options = {})
  current_user =
    case user
    when Symbol
      create :user, user
    when User
      user
    when nil
      # need spire for requests but current_user should still be nil
      session[:spire] = build(:user).spire
      nil
    else raise ArgumentError, 'Invalid user type'
    end
  if options.key? :view
    assign :current_user, current_user
  else session[:user_id] = current_user.try :id
  end
end
