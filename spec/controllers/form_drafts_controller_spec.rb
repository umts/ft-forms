# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormDraftsController do
  describe 'DELETE #destroy' do
    before do
      @draft = create :form_draft
    end

    let :submit do
      delete :destroy, params: { id: @draft.id }
    end

    context 'not staff' do
      before do
        when_current_user_is :not_staff
      end

      it 'does not allow access' do
        expect_any_instance_of(FormDraft)
          .not_to receive :destroy
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET #edit' do
    before do
      @draft = create :form_draft
    end

    let :submit do
      get :edit, params: { id: @draft.id }
    end

    context 'not staff' do
      before do
        when_current_user_is :not_staff
      end

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET #new' do
    before do
      @form = create :form
    end

    let :submit do
      get :new, params: { form_id: @form.id }
    end

    context 'not staff' do
      before do
        when_current_user_is :not_staff
      end

      it 'does not allow access' do
        expect_any_instance_of(Form)
          .not_to receive :find_or_create_draft
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'staff' do
      before do
        @user = create :user, :staff
        when_current_user_is @user
      end

      it 'creates a draft for the correct form' do
        expect { submit }
          .to change { @form.drafts.count }
          .by 1
      end

      it 'redirects to the edit page for that draft' do
        submit
        draft = assigns.fetch :draft
        expect(response).to redirect_to edit_form_draft_path(draft)
      end
    end
  end

  describe 'GET #show' do
    before do
      @draft = create :form_draft
    end

    let :submit do
      get :show, params: { id: @draft.id }
    end

    context 'not staff' do
      before do
        when_current_user_is :not_staff
      end

      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
        expect(response).not_to render_template 'show'
      end
    end

    context 'staff' do
      before do
        when_current_user_is :staff
      end

      it 'assigns the correct draft to the draft instance variable' do
        submit
        expect(assigns.fetch(:draft)).to eql @draft
      end

      it 'renders the show template' do
        submit
        expect(response).to render_template 'show'
      end
    end
  end

  describe 'POST #create' do
    before do
      @params = { form_draft: { name: 'a name' } }
    end

    let :submit do
      post :create, params: @params
    end

    context 'not staff' do
      before do
        when_current_user_is :not_staff
      end

      it 'does not allow access' do
        expect(FormDraft).not_to receive :new
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'staff' do
      before do
        @params[:form_draft][:name] = ''
        when_current_user_is :staff
      end

      context 'errors' do
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
    before do
      @draft = create :form_draft
      @changes = { 'name' => 'a new name' }
    end

    let :submit do
      post :update, params: { id: @draft,
                              form_draft: @changes }
    end

    context 'not staff' do
      before do
        when_current_user_is :not_staff
      end

      it 'does not allow access' do
        expect_any_instance_of(FormDraft)
          .not_to receive :update
        submit
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'staff' do
      before do
        when_current_user_is :staff
        @changes = { 'name' => '' }
      end

      context 'errors' do
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
    before do
      @draft = create :form_draft
    end

    let :submit do
      post :update_form, params: { id: @draft.id }
    end

    context 'not staff' do
      before do
        when_current_user_is :not_staff
      end

      it 'does not allow access' do
        expect_any_instance_of(FormDraft)
          .not_to receive :update_form!
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
