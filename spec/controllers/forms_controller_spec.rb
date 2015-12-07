require 'rails_helper'

describe FormsController do
  describe 'GET #index' do
    before :each do
      @form_1 = create :form
      @form_2 = create :form
      @form_3 = create :form
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
          xhr :get, :index
          expect(response).to have_http_status :unauthorized
          expect(response.body).to be_blank
        end
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      it 'puts all the forms in the correct instance variable' do
        submit
        expect(assigns.fetch :forms).to include @form_1, @form_2, @form_3
      end
      it 'renders the index' do
        submit
        expect(response).to render_template 'index'
      end
    end
  end

  describe 'GET #meet_and_greet (root)' do
    before :each do
      @form = create :form, name: 'Meet & Greet Request Form'
    end
    let :submit do
      get :meet_and_greet
    end
    context 'whether staff or not' do
      [:not_staff, :staff].each do |user_type|
        before :each do
          when_current_user_is user_type
        end
        it 'assigns the correct form to the correct instance variable' do
          submit
          expect(assigns.fetch :form).to eql @form
        end
        it 'sets submit to true' do
          submit
          expect(assigns.fetch :submit).to eql true
        end
        it 'renders the show template' do
          submit
          expect(response).to render_template :show
        end
      end
    end
  end

  describe 'GET #show' do
    before :each do
      @form = create :form
    end
    let :submit do
      get :show, id: @form.id
    end
    context 'whether staff or not' do
      [:not_staff, :staff].each do |user_type|
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
  end

  describe 'POST #submit' do
    before :each do
      @form = create :form
      @field = create :field, form: @form
      @responses = {
        @field.unique_name        => 'A response',
        @field.unique_prompt_name => @field.prompt
      }
    end
    let :submit do
      post :submit, id: @form.id, responses: @responses,
                    user: @user, reply_to: @form.reply_to
    end
    context 'whether staff or not' do
      [:not_staff, :staff].each do |user_type|
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
              .with(@form, @responses)
              .and_return mail
            expect(mail).to receive(:deliver_now).and_return true
          end
          it 'sends the form confirmation' do
            mail = ActionMailer::MessageDelivery.new(FtFormsMailer,
                                                     :send_confirmation)
            expect(FtFormsMailer)
              .to receive(:send_confirmation)
              .with(@current_user, @responses, @form.reply_to)
              .and_return mail
            expect(mail).to receive(:deliver_now).and_return true
            submit
          end
          it 'redirects to the thank you page for the form' do
            submit
            expect(response).to redirect_to thank_you_form_url(@form)
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
        # user attributes which are used to create a user... snrk
        @user = {
          first_name: 'John',
          last_name:  'Doe',
          email:      'johndoe@test.host'
        }
      end
      it 'creates a user' do
        expect { submit }
          .to change { User.count }
          .by 1
      end
    end
  end

  describe 'GET #thank_you' do
    before :each do
      @form = create :form
    end
    let :submit do
      get :thank_you, id: @form.id
    end
    context 'whether staff or not' do
      [:not_staff, :staff].each do |user_type|
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

  describe 'PUT #update' do
    before :each do
      @form = create :form
      @changes = Hash['name', 'a new name']
    end
    let :submit do
      put :update, id: @form.id, form: @changes
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect_any_instance_of(Form)
          .not_to receive :update
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      context 'invalid input' do
        before :each do
          @changes = Hash['name', '']
        end
        it 'shows errors' do
          expect_redirect_to_back { submit }
          expect(flash.keys).to include 'errors'
        end
      end
      context 'valid input' do
        it 'updates the form with the changes' do
          expect { submit }.to change { @form.reload.name }
        end
        it 'adds a message to the flash' do
          submit
          expect(flash['message']).not_to be_empty
        end
        it 'redirects to the index' do
          submit
          expect(response).to redirect_to forms_url
        end
      end
    end
  end
end
