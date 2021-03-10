# frozen_string_literal: true

# Sets current user based on acceptable values:
# 1. a symbol name of a user factory trait
# 2. a specific instance of User
# 3. nil
def when_current_user_is(user)
  current_user =
    case user
    when Symbol then create(:user, user)
    when User, nil then user
    else raise ArgumentError, 'Invalid user type'
    end
  set_current_user(current_user)
end

# rubocop:disable Naming/AccessorMethodName
def set_current_user(user)
  case self.class.metadata[:type]
  when :view
    assign :current_user, user
  when :feature, :system
    page.set_rack_session user_id: user.try(:id)
  when :controller
    session[:user_id] = user.try(:id)
    session[:spire] = user.try(:spire) || build(:user).spire
  end
end
# rubocop:enable Naming/AccessorMethodName
