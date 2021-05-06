# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormsController do
  describe 'GET #index' do
    subject(:submit) { get :index }

    before { create_list(:form, 3) }

    context 'when the user is not staff' do
      before { when_current_user_is :not_staff }

      context 'with an HTML request' do
        it 'does not allow access' do
          submit
          expect(response).to have_http_status :unauthorized
        end

        it 'does not show anything' do
          submit
          expect(response).not_to render_template :index
        end
      end

      context 'with an XHR request' do
        before do
          headers = { 'HTTP_X_REQUESTED_WITH' => 'XMLHTTPRequest' }
          request.headers.merge! headers
        end

        it 'does not allow access' do
          submit
          expect(response).to have_http_status :unauthorized
        end

        it 'does not show anything' do
          submit
          expect(response.body).to be_empty
        end
      end
    end
  end

  describe 'GET #show' do
    subject :submit do
      get :show, params: { id: form.slug }
    end

    let(:form) { create :form }

    %i[not_staff staff].each do |user_type|
      context "when the user is #{user_type}" do
        before { when_current_user_is user_type }

        it 'assigns the correct instance variable' do
          submit
          expect(assigns.fetch(:form)).to eq(form)
        end

        it 'displays the correct template' do
          submit
          expect(response).to render_template(:show)
        end
      end
    end

    context 'when there is no current user' do
      let(:new_user) { assigns.fetch :placeholder }

      before do
        when_current_user_is nil
        request.env['mail'] = 'user@example.com'
        request.env['givenName'] = 'bob'
        request.env['surName'] = 'dole'
      end

      it 'populates a placeholder variable with user first name' do
        submit
        expect(new_user.first_name).to eql 'bob'
      end

      it 'populates a placeholder variable with user last name' do
        submit
        expect(new_user.last_name).to eql 'dole'
      end

      it 'populates a placeholder variable with user email' do
        submit
        expect(new_user.email).to eql 'user@example.com'
      end
    end
  end

  describe 'POST #submit' do
    subject :submit do
      post :submit, params: {
        id: form.id,
        responses: responses,
        reply_to: 'email',
        user: { first_name: 'John', last_name: 'Smith', email: 'jsmith@example.com' }
      }
    end

    let(:form) { create :form }
    let(:responses) do
      field = create :field, form: form
      { field.unique_name => 'A response',
        field.unique_prompt_name => field.prompt }
    end

    %i[not_staff staff].each do |user_type|
      context "when the user is #{user_type}" do
        let(:current_user) { create :user, user_type }
        let :form_mail do
          ActionMailer::MessageDelivery.new(FtFormsMailer, :send_form)
        end
        let :conf_mail do
          ActionMailer::MessageDelivery.new(FtFormsMailer, :send_confirmation)
        end

        before do
          when_current_user_is current_user
          allow(FtFormsMailer).to receive(:send_form).and_return(form_mail)
          allow(FtFormsMailer).to receive(:send_confirmation).and_return(conf_mail)
          allow(form_mail).to receive(:deliver_now).and_return true
          allow(conf_mail).to receive(:deliver_now).and_return true
        end

        it 'constructs the form email with the correct arguments' do
          submit
          expect(FtFormsMailer).to have_received(:send_form)
            .with(form, responses, current_user)
        end

        it 'sends the form email' do
          submit
          expect(form_mail).to have_received(:deliver_now)
        end

        it 'constructs the confirmation email with the correct arguments' do
          submit
          expect(FtFormsMailer).to have_received(:send_confirmation)
            .with(current_user, responses, 'email')
        end

        it 'sends the form confirmation' do
          submit
          expect(conf_mail).to have_received(:deliver_now)
        end

        it 'redirects to the thank you page for the form' do
          submit
          expect(response).to redirect_to thank_you_form_url(form)
        end

        it 'updates the current user email' do
          submit
          expect(current_user.reload.email).to eq 'jsmith@example.com'
        end

        it 'updates the current user first_name' do
          submit
          expect(current_user.reload.first_name).to eq 'John'
        end

        it 'updates the current user last_name' do
          submit
          expect(current_user.reload.last_name).to eq 'Smith'
        end
      end
    end

    context 'when the user does not exist yet' do
      before { when_current_user_is nil }

      it 'creates a user' do
        expect { submit }.to change(User, :count).by 1
      end

      it 'sets the current user based on spire' do
        session['spire'] = '34512390@umass.edu'
        submit
        expect(assigns[:current_user].spire).to eq '34512390@umass.edu'
      end
    end
  end

  describe 'GET #thank_you' do
    subject :submit do
      get :thank_you, params: { id: form.id }
    end

    let(:form) { create :form }

    %i[not_staff staff].each do |user_type|
      context "when the current user is #{user_type}" do
        before { when_current_user_is user_type }

        it 'finds a form based on its ID' do
          submit
          expect(assigns.fetch(:form)).to eql form
        end

        it 'displays the thank you page' do
          submit
          expect(response).to render_template :thank_you
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    subject :submit do
      delete :destroy, params: { id: form.id }
    end

    let(:form) { create :form }
    let(:forms) { Form.friendly }

    context 'when the user is not staff' do
      before do
        when_current_user_is :not_staff
        allow(Form).to receive(:friendly).and_return(forms)
        allow(forms).to receive(:find).and_return(form)
        allow(form).to receive(:destroy)
      end

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end

      it 'does not destroy anything ' do
        submit
        expect(form).not_to have_received(:destroy)
      end
    end
  end
end
