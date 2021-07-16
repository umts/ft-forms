# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController do
  describe 'DELETE #destroy' do
    subject(:submit) { delete :destroy }

    before do
      when_current_user_is :anyone
      allow(session).to receive(:clear)
    end

    context 'when not in the production environment' do
      it 'redirects to dev_login' do
        submit
        expect(response).to redirect_to dev_login_path
      end

      it 'clears the session' do
        submit
        expect(session).to have_received(:clear)
      end
    end

    context 'when in the production environment' do
      before do
        allow(Rails.env).to receive(:production?).and_return(true)
      end

      it 'redirects to something about Shibboleth' do
        address = '/Shibboleth.sso/Logout?return=https://webauth.umass.edu/Logout'
        submit
        expect(response).to redirect_to(address)
      end

      it 'clears the session' do
        submit
        expect(session).to have_received(:clear)
      end
    end
  end

  describe 'GET #dev_login' do
    subject(:submit) { get :dev_login }

    before { when_current_user_is nil }

    it 'assigns instance variables' do
      submit
      expect(assigns.keys).to include 'not_staff', 'staff'
    end

    it 'renders correct template' do
      submit
      expect(response).to render_template 'dev_login'
    end
  end

  describe 'POST #dev_login' do
    subject(:submit) do
      post :dev_login, params: params
    end

    let(:user) { create :user, :not_staff }
    let(:params) { { user_id: user.id } }

    before { when_current_user_is nil }

    context 'with a user specified' do
      it 'creates a session for the user specified' do
        submit
        expect(session[:user_id]).to eq user.id
      end
    end

    context 'with a SPIRE specified' do
      let(:spire) { '13243546@umass.edu' }
      let(:params) { { spire: spire } }

      it 'accepts a SPIRE also' do
        submit
        expect(session[:spire]).to eql spire
      end
    end

    context 'when the user logging in is not staff' do
      it 'redirects to forms index' do
        submit
        expect(response).to redirect_to forms_url
      end
    end

    context 'when the user logging in is staff' do
      let(:user) { create :user, :staff }

      it 'redirects to forms index' do
        submit
        expect(response).to redirect_to forms_url
      end
    end
  end

  describe 'GET #unauthenticated' do
    subject(:submit) { get :unauthenticated }

    it 'renders the correct template' do
      expect(submit).to render_template :unauthenticated
    end
  end
end
