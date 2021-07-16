# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/application.haml' do
  subject(:page) { rendered }

  context 'when current user is present' do
    before do
      when_current_user_is :anyone
      render
    end

    it { is_expected.to have_tag 'a', with: { href: '/sessions/destroy' } }
  end

  context 'when current user is staff' do
    let(:user) { create :user, :staff }

    before do
      when_current_user_is user
      render
    end

    it { is_expected.to have_tag 'a', with: { href: forms_path } }

    it 'displays the full name of the user' do
      expect(rendered).to have_tag '#current-user-name', text: user.full_name
    end
  end

  context 'with a message present in the flash' do
    before do
      flash[:message] = 'this is totally a message'
      render
    end

    it 'displays the message' do
      expect(rendered).to have_tag '#flash' do
        with_tag '#message', text: 'this is totally a message'
      end
    end
  end

  context 'with errors present in the flash' do
    let(:errors) { %w[these are errors] }

    before do
      flash[:errors] = errors
      render
    end

    it 'displays a list of errors' do
      expect(rendered).to have_tag '#flash' do
        with_tag '#errors' do
          errors.each { |error| with_tag 'li', text: error }
        end
      end
    end
  end
end
