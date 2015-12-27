require 'codeclimate-test-reporter'
require 'factory_girl_rails'
require 'simplecov'

CodeClimate::TestReporter.start if ENV['CI']
SimpleCov.start 'rails' do
  refuse_coverage_drop
end

RSpec.configure do |config|
  config.before :all do
    FactoryGirl.reload
  end
  config.include FactoryGirl::Syntax::Methods
end

def expect_redirect_to_back(path = 'http://test.host/redirect', &block)
  request.env['HTTP_REFERER'] = path
  block.call
  expect(response).to have_http_status :redirect
  expect(response).to redirect_to path
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
