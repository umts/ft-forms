require 'rails_helper'

describe FormDraftsController do
  describe 'GET #edit' do
    before :each do
      @draft = create :form_draft
    end
    let :submit do
      get :edit, form_draft_id: @draft.id
    end
    it 'assigns the correct draft to the draft instance variable'
    it 'adds a field to the draft, in memory only'
    it 'renders the edit template'
  end
  describe 'GET #new' do
    before :each do
      @form = create :form
    end
    let :submit do
      get :new, form_id: @form.id
    end
    it 'creates a draft for the correct form'
    it 'redirects to the edit page for that form'
  end
  describe 'GET #show' do
    before :each do
      @draft = create :form_draft
    end
    let :submit do
      get :show, form_draft_id: @draft.id
    end
    it 'assigns the correct draft to the draft instance variable'
    it 'renders the show template'
  end
  describe 'POST #update' do
    before :each do
      @draft = create :form_draft
      @changes = Hash['name', 'a new name']
    end
    let :submit do
      post :update, form_draft_id: @draft,
                    form_draft: @changes,
                    commit: @commit
    end
    it 'updates the draft with the changes given'
    context 'commit is Save changes and continue editing' do
      it 'redirects to the edit path for the draft'
    end
    context 'commit is Preview changes' do
      it 'renders the show page'
    end
  end
end
