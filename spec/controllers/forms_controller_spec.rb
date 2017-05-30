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

  describe 'GET #show' do
    before :each do
      @form = create :form
    end
    let :submit do
      get :show, id: @form.slug
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
        @field.unique_name        => 'A response',
        @field.unique_prompt_name => @field.prompt
      }
      @user_attributes = { first_name: 'John',
                           last_name: 'Smith',
                           email: 'jsmith@example.com'
      }
    end
    let :submit do
      post :submit, id: @form.id, responses: @responses,
                    user: @user_attributes, reply_to: @form.reply_to
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
              .with(@form, @responses, @current_user)
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
          it 'updates the current_user object' do
            [:email, :first_name, :last_name].each do |attribute|
              expect(@current_user.send(attribute))
                .not_to eql @user_attributes[attribute]
            end
            submit
            [:email, :first_name, :last_name].each do |attribute|
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
          expect { submit }.to redirect_back
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
  describe 'GET #new' do
    let :submit do
      get :new
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect_any_instance_of(Form)
          .not_to receive :create
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      it 'creates a form' do
        expect{ submit }.to change {Form.count}.by 1
      end
      it 'gives the form a name' do
        submit
        expect(assigns.fetch(:draft).name).to eql 'new-form'
      end
      it 'creates a draft for the current user' do
        submit
        expect(assigns[:current_user].form_drafts).to include assigns[:draft]
      end
      it 'redirects to edit form page' do
        submit
        expect(response).to redirect_to edit_form_draft_path assigns[:draft]
      end
    end
  end  
  describe 'DELETE #destroy' do
    before :each do
      @form = create :form
    end
    let :submit do
      delete :destroy, id: @form.id
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
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      it 'destroys form' do
        expect{submit}.to change {Form.count}.by -1 
      end
      it 'redirects to form page' do
        submit
        expect(response).to redirect_to forms_path
      end
    end
  end
end
