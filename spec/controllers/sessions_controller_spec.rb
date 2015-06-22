require 'rails_helper'

describe SessionsController do
  describe 'DELETE #destroy' do
    before :each do
      @user = create :user
      when_current_user_is @user
    end
    let :submit do
      delete :destroy
    end
    context 'development' do
      before :each do
        expect(Rails.env)
          .to receive(:production?)
          .and_return false
      end
      it 'redirects to dev_login' do
        submit
        expect(response).to redirect_to dev_login_sessions_path
      end
      it 'clears the session' do
        expect_any_instance_of(ActionController::TestSession)
          .to receive :clear
        submit
      end
    end
    context 'production' do
      before :each do
        expect(Rails.env)
          .to receive(:production?)
          .and_return true
      end
      it 'clears the session'
    end
  end

  describe 'GET #dev_login' do
    let :submit do
      get :dev_login
    end
    context 'production' do
      before :each do
        expect(Rails.env)
          .to receive(:production?)
          .and_return true
      end
      it 'redirects to new path' do
        submit
        expect(response).to redirect_to new_session_path
      end
    end
    context 'development' do
      before :each do
        expect(Rails.env)
          .to receive(:production?)
          .and_return false
      end
      it 'assigns instance variables' do
        submit
        expect(assigns.keys).to include 'not_staff', 'staff'
      end
      it 'renders correct template' do
        submit
        expect(response).to render_template 'dev_login'
      end
    end
  end

  describe 'POST #dev_login' do
    before :each do
      @user = create :user
    end
    let :submit do
      post :dev_login, user_id: @user.id
    end
    context 'production' do
      before :each do
        expect(Rails.env)
          .to receive(:production?)
          .and_return true
      end
      it 'redirects to new path' do
        submit
        expect(response).to redirect_to new_session_path
      end
    end
    context 'development' do
      before :each do
        expect(Rails.env)
          .to receive(:production?)
          .and_return false
      end
      it 'creates a session for the user specified' do
        submit
        expect(session[:user_id]).to eql @user.id
      end
      context 'not staff' do
        before :each do
          @user = create :user, :not_staff
        end
        it 'redirects to the meet and greet form' do
          submit
          expect(response).to redirect_to meet_and_greet_forms_url
        end
      end
      context 'staff' do
        before :each do
          @user = create :user, :staff
        end
        it 'redirects to the forms index' do
          submit
          expect(response).to redirect_to forms_url
        end
      end
    end
  end

  describe 'GET #new' do
    let :submit do
      get :new
    end
    context 'production' do
      before :each do
        expect(Rails.env)
          .to receive(:production?)
          .and_return true
      end
    end
    context 'development' do
      before :each do
        expect(Rails.env)
          .to receive(:production?)
          .and_return false
      end
      it 'redirects to dev login path' do
        submit
        expect(response).to redirect_to dev_login_sessions_path
      end
    end
  end
end
