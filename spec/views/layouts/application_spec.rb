require 'rails_helper'
include RSpecHtmlMatchers

describe 'layouts/application.haml' do
  context 'current user is present' do
    before :each do
      @user = create :user
      when_current_user_is @user, view: true
    end
    it 'displays the link to logout' do
      render
      expect(rendered).to have_tag 'a', with: { href: '/sessions/destroy' }
    end
    context 'current user is staff' do
      before :each do
        when_current_user_is :staff, view: true
      end
      it 'has a link to the forms' do
        render
        expect(rendered).to have_tag 'a', with: { href: forms_path }
      end
      it 'displays the full name of the user' do
        render
        expect(rendered).to include @user.full_name
      end
    end
  end
  context 'message present in flash' do
    before :each do
      flash[:message] = 'this is totally a message'
    end
    it 'displays the message' do
      render
      expect(rendered).to have_tag '#message' do
        with_text(/this is totally a message/)
      end
    end
  end
  context 'errors present in flash' do
    before :each do
      flash[:errors] = %w(these are errors)
    end
    it 'displays a list of errors' do
      render
      expect(rendered).to include 'these', 'are', 'errors'
    end
  end
end
