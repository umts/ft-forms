# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/application.haml' do
  context 'current user is present' do
    before do
      @user = create :user
      when_current_user_is @user
    end

    it 'displays the link to logout' do
      render
      expect(rendered).to have_tag 'a', with: { href: '/sessions/destroy' }
    end

    context 'current user is staff' do
      before do
        when_current_user_is :staff
      end

      it 'has a link to the forms' do
        render
        expect(rendered).to have_tag 'a', with: { href: forms_path }
      end

      it 'displays the full name of the user' do
        render
        expect(rendered).to have_tag '#current-user-name' do
          with_text @user.full_name
        end
      end
    end
  end

  context 'message present in flash' do
    before do
      flash[:message] = 'this is totally a message'
    end

    it 'displays the message' do
      render
      expect(rendered).to have_tag '#flash' do
        with_tag '#message' do
          with_text(/this is totally a message/)
        end
      end
    end
  end

  context 'errors present in flash' do
    before do
      flash[:errors] = %w[these are errors]
    end

    it 'displays a list of errors' do
      render
      expect(rendered).to have_tag '#flash' do
        with_tag '#errors' do
          with_tag 'li', text: 'these'
          with_tag 'li', text: 'are'
          with_tag 'li', text: 'errors'
        end
      end
    end
  end
end
