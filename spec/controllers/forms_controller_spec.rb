# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormsController do
  describe 'GET #index' do
    before :each do
      @form1 = create :form
      @form2 = create :form
      @form3 = create :form
    end
    let :submit do
      get :index
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      context 'HTML request' do
        it 'does not allow access' do
          submit
          expect(response).to have_http_status :unauthorized
          expect(response).not_to render_template :index
        end
      end
      context 'XHR request' do
        it 'does not allow access' do
          headers = { 'HTTP_X_REQUESTED_WITH' => 'XMLHTTPRequest' }
          request.headers.merge! headers
          get :index
          expect(response).to have_http_status :unauthorized
          expect(response.body).to be_empty
        end
      end
    end
  end

  describe 'GET #show' do
    before :each do
      @form = create :form
    end
    let :submit do
      get :show, params: { id: @form.slug }
    end
    context 'whether staff or not' do
      %i[not_staff staff].each do |user_type|
        before :each do
          when_current_user_is user_type
        end
        it 'assigns the correct instance variable' do
          submit
          expect(assigns.fetch :form).to eql @form
        end
        it 'displays the correct template' do
          submit
          expect(response).to render_template :show
        end
      end
    end
    context 'current user is nil' do
      it 'populates a placeholder variable with user attributes' do
        when_current_user_is nil
        request.env['mail'] = 'user@example.com'
        request.env['givenName'] = 'bob'
        request.env['surName'] = 'dole'
        submit
        new_user = assigns.fetch :placeholder
        expect(new_user.first_name).to eql 'bob'
        expect(new_user.last_name).to eql 'dole'
        expect(new_user.email).to eql 'user@example.com'
      end
    end
  end

  describe 'POST #submit' do
    before :each do
      @form = create :form
      @field = create :field, form: @form
      @responses = {
        @field.unique_name => 'A response',
        @field.unique_prompt_name => @field.prompt
      }
      @user_attributes = { first_name: 'John',
                           last_name: 'Smith',
                           email: 'jsmith@example.com' }
    end
    let :submit do
      post :submit, params: { id: @form.id, responses: @responses,
                              user: @user_attributes, reply_to: 'email' }
    end
    context 'whether staff or not' do
      %i[not_staff staff].each do |user_type|
        before :each do
          @current_user = create :user, user_type
          when_current_user_is @current_user
        end
        context 'sending form is successful' do
          before :each do
            mail = ActionMailer::MessageDelivery.new(FtFormsMailer,
                                                     :send_form)
            expect(FtFormsMailer)
              .to receive(:send_form)
              .with(@form, @responses, @current_user)
              .and_return mail
            expect(mail).to receive(:deliver_now).and_return true
          end
          it 'sends the form confirmation' do
            mail = ActionMailer::MessageDelivery.new(FtFormsMailer,
                                                     :send_confirmation)
            expect(FtFormsMailer)
              .to receive(:send_confirmation)
              .with(@current_user, @responses, 'email')
              .and_return mail
            expect(mail).to receive(:deliver_now).and_return true
            submit
          end
          it 'redirects to the thank you page for the form' do
            submit
            expect(response).to redirect_to thank_you_form_url(@form)
          end
          it 'updates the current_user object' do
            %i[email first_name last_name].each do |attribute|
              expect(@current_user.send(attribute))
                .not_to eql @user_attributes[attribute]
            end
            submit
            %i[email first_name last_name].each do |attribute|
              expect(@current_user.reload.send(attribute))
                .to eql @user_attributes[attribute]
            end
          end
        end
        context 'sending form is unsuccessful' do
          # TODO
        end
      end
    end
    context 'user does not exist yet' do
      before :each do
        when_current_user_is nil
      end
      it 'creates a user' do
        expect { submit }
          .to change { User.count }
          .by 1
      end
      context 'session has no user_id key' do
        it 'sets the current user based on spire' do
          session.delete('user_id')
          submit
          expect(session['spire']).to eql assigns[:current_user].spire
        end
      end
    end
  end

  describe 'GET #thank_you' do
    before :each do
      @form = create :form
    end
    let :submit do
      get :thank_you, params: { id: @form.id }
    end
    context 'whether staff or not' do
      %i[not_staff staff].each do |user_type|
        before :each do
          when_current_user_is user_type
        end
        it 'finds a form based on its ID' do
          submit
          expect(assigns.fetch :form).to eql @form
        end
        it 'displays the thank you page' do
          submit
          expect(response).to render_template :thank_you
        end
      end
    end
  end

  describe 'GET #new' do
    let :submit do
      get :new
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect(Form).not_to receive :new
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
  end
  describe 'DELETE #destroy' do
    before :each do
      @form = create :form
    end
    let :submit do
      delete :destroy, params: { id: @form.id }
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect_any_instance_of(Form)
          .not_to receive :destroy
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
