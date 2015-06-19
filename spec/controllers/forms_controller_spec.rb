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
    it 'puts all the forms in the correct instance variable' do
      submit
      expect(assigns.fetch :forms).to include @form_1, @form_2, @form_3
    end
    it 'renders the index' do
      submit
      expect(response).to render_template 'index'
    end
  end

  describe 'GET #meet_and_greet (root)' do
    before :each do
      @form = create :form, name: 'Meet & Greet Request Form'
    end
    let :submit do
      get :meet_and_greet
    end
    it 'assigns the correct form to the correct instance variable' do
      submit
      expect(assigns.fetch :form).to eql @form
    end
    it 'renders the show template' do
      submit
      expect(response).to render_template :show
    end
  end

  describe 'GET #preview' do
    before :each do
      @form = create :form
      @changes = Hash['name', 'A new name']
    end
    let :submit do
      get :preview, id: @form.id, form: @changes
    end
    it 'assigns the correct form to the correct instance variable' do
      submit
      expect(assigns.fetch :form).to eql @form
    end
    it 'assigns the attributes to the form' do
      expect_any_instance_of(Form)
        .to receive(:assign_attributes)
        .with @changes
      submit
    end
    it 'does not save any changes' do
      expect { submit }.not_to change { @form.reload }
    end
    it 'passes the changes through as an instance variable' do
      submit
      expect(assigns.fetch :changes).to eql @changes
    end
  end

  describe 'GET #show' do
    before :each do
      @form = create :form
    end
    let :submit do
      get :show, id: @form.id
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

  describe 'POST #submit' do
    before :each do
      @form = create :form
      @responses = Hash['Email', 'example value']
    end
    let :submit do
      post :submit, id: @form.id, responses: @responses
    end
    context 'sending form is successful' do
      before :each do
        expect(FtFormsMailer)
          .to receive(:send_form)
          .with(@responses)
          .and_return true
      end
      it 'sends the form confirmation' do
        expect(FtFormsMailer)
          .to receive(:send_confirmation)
          .with(@responses)
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

  describe 'GET #thank_you' do
    before :each do
      @form = create :form
    end
    let :submit do
      get :thank_you, id: @form.id
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

  describe 'POST #update' do
    before :each do
      @form = create :form
      @changes = Hash['name', 'a new name']
    end
    let :submit do
      post :update, id: @form.id, form: @changes
    end
    context 'change is successful' do
      it 'stores a message in flash' do
        submit
        expect(flash.keys).to include 'message'
      end
      it 'redirects to the index' do
        submit
        expect(response).to redirect_to forms_url
      end
    end
    context 'change is not successful' do
      before :each do
        # TODO
      end
      it 'TODO'
    end
  end
end
