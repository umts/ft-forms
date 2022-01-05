# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormDraftsController do
  describe 'DELETE #destroy' do
    subject :submit do
      delete :destroy, params: { id: draft.id }
    end

    let(:draft) { create :form_draft }
    let(:drafts) { FormDraft.all }

    context 'when the user is not staff' do
      before do
        when_current_user_is :not_staff
        allow(FormDraft).to receive(:includes).and_return(drafts)
        allow(drafts).to receive(:find).and_return draft
        allow(draft).to receive(:destroy)
      end

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end

      it 'does not destroy anything' do
        submit
        expect(draft).not_to have_received(:destroy)
      end
    end
  end

  describe 'GET #edit' do
    subject :submit do
      get :edit, params: { id: draft.id }
    end

    let(:draft) { create :form_draft }

    context 'when the user is not staff' do
      before { when_current_user_is :not_staff }

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET #new' do
    subject :submit do
      get :new, params: { form_id: form.id }
    end

    let(:form) { create :form }

    context 'when the user is not staff' do
      before { when_current_user_is :not_staff }

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the user is staff' do
      before { when_current_user_is :staff }

      it 'creates a draft for the correct form' do
        expect { submit }.to change { form.drafts.count }.by 1
      end

      it 'redirects to the edit page for that draft' do
        submit
        draft = assigns.fetch :draft
        expect(response).to redirect_to edit_form_draft_path(draft)
      end
    end
  end

  describe 'GET #show' do
    subject :submit do
      get :show, params: { id: draft.id }
    end

    let(:draft) { create :form_draft }

    context 'when the user is not staff' do
      before { when_current_user_is :not_staff }

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when the user is staff' do
      before { when_current_user_is :staff }

      it 'assigns the correct draft to the draft instance variable' do
        submit
        expect(assigns.fetch(:draft)).to eql draft
      end

      it 'renders the show template' do
        submit
        expect(response).to render_template 'show'
      end
    end
  end

  describe 'POST #create' do
    subject :submit do
      post :create, params: params
    end

    let(:params) { { form_draft: { name: 'a name' } } }

    context 'when the user is not staff' do
      before { when_current_user_is :not_staff }

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end

      it 'does not make a new draft' do
        allow(FormDraft).to receive(:new)
        submit
        expect(FormDraft).not_to have_received(:new)
      end
    end

    context 'when the user is staff' do
      before { when_current_user_is :staff }

      context 'with errors' do
        before { params[:form_draft][:name] = '' }

        it 'puts errors in the flash' do
          submit
          expect(flash[:errors]).not_to be_empty
        end

        it 'renders the new page' do
          submit
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'POST #update' do
    subject :submit do
      post :update, params: { id: draft, form_draft: changes }
    end

    let(:drafts) { FormDraft.all }
    let(:draft) { create :form_draft }
    let(:changes) { { 'name' => 'a new name' } }

    context 'when the user is not staff' do
      before do
        when_current_user_is :not_staff
        allow(FormDraft).to receive(:includes).and_return(drafts)
        allow(drafts).to receive(:find).and_return draft
        allow(draft).to receive(:update)
      end

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end

      it 'does not update anything' do
        submit
        expect(draft).not_to have_received(:update)
      end
    end

    context 'when the user is staff' do
      before { when_current_user_is :staff }

      context 'with errors' do
        let(:changes) { { 'name' => '' } }

        it 'puts errors in the flash' do
          submit
          expect(flash[:errors]).not_to be_empty
        end

        it 'renders the new page' do
          submit
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'POST #update_form' do
    subject :submit do
      post :update_form, params: { id: draft.id }
    end

    let(:draft) { create :form_draft }
    let(:drafts) { FormDraft.all }

    context 'when the user is not staff' do
      before do
        when_current_user_is :not_staff
        allow(FormDraft).to receive(:includes).and_return(drafts)
        allow(drafts).to receive(:find).and_return draft
        allow(draft).to receive(:update_form!)
      end

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end

      it 'does not update the form' do
        submit
        expect(draft).not_to have_received(:update_form!)
      end
    end
  end
end
