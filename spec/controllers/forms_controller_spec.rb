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
end
