require 'rails_helper'

describe FormsController do
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
end
