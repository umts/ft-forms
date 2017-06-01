require 'rails_helper'

describe FormDraftsController do
  describe 'DELETE #destroy' do
    before :each do
      @draft = create :form_draft
    end
    let :submit do
      delete :destroy, id: @draft.id
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect_any_instance_of(FormDraft)
          .not_to receive :destroy
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      it 'assigns the correct draft to the draft instance variable' do
        submit
        expect(assigns.fetch :draft).to eql @draft
      end
      it 'destroys the draft' do
        expect_any_instance_of(FormDraft)
          .to receive :destroy
        submit
      end
      it 'includes a flash message' do
        submit
        expect(flash[:message]).not_to be_empty
      end
      it 'redirects to the forms url' do
        submit
        expect(response).to redirect_to forms_url
      end
    end
  end

  describe 'GET #edit' do
    before :each do
      @draft = create :form_draft
    end
    let :submit do
      get :edit, id: @draft.id
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      it 'assigns the correct draft to the draft instance variable' do
        submit
        expect(assigns.fetch :draft).to eql @draft
      end
      it 'adds a field to the draft, in memory only' do
        expect { submit }
          .not_to change { @draft.fields.count }
        # Factory draft has 0 fields by default
        expect(assigns.fetch(:draft).fields.size).to be 1
      end
      it 'renders the edit template' do
        submit
        expect(response).to render_template 'edit'
      end
    end
  end

  describe 'GET #new' do
    before :each do
      @form = create :form
    end
    let :submit do
      get :new, form_id: @form.id
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect_any_instance_of(Form)
          .not_to receive :create_draft
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
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

  describe 'POST #move_field' do
    before :each do
      @draft = create :form_draft
      @field = create :field, form_draft: @draft
      @direction = :up
    end
    let :submit do
      post :move_field,
           id: @draft.id,
           number: @field.number,
           direction: @direction
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect_any_instance_of(FormDraft)
          .not_to receive(:move_field)
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      it 'assigns the correct draft to the draft instance variable' do
        submit
        expect(assigns.fetch :draft).to eql @draft
      end
      it 'calls #move_field on the draft' do
        expect_any_instance_of(FormDraft)
          .to receive(:move_field)
          .with(@field.number, @direction)
        submit
      end
      it 'redirects to the edit path' do
        submit
        expect(response).to redirect_to edit_form_draft_path(@draft)
      end
    end
  end

  describe 'POST #remove_field' do
    before :each do
      @draft = create :form_draft
      @field = create :field, form_draft: @draft
    end
    let :submit do
      post :remove_field, id: @draft.id, number: @field.number
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect_any_instance_of(FormDraft)
          .not_to receive :remove_field
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      it 'assigns the correct form draft to the draft instance variable' do
        submit
        expect(assigns.fetch :draft).to eql @draft
      end
      it 'calls #remove_field on the draft with the number in question' do
        expect_any_instance_of(FormDraft)
          .to receive(:remove_field)
          .with @field.number
        submit
      end
      it 'redirects to the edit path for the draft' do
        submit
        expect(response).to redirect_to edit_form_draft_path(@draft)
      end
    end
  end

  describe 'GET #show' do
    before :each do
      @draft = create :form_draft
    end
    let :submit do
      get :show, id: @draft.id
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        submit
        expect(response).to have_http_status :unauthorized
        expect(response).not_to render_template 'show'
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      it 'assigns the correct draft to the draft instance variable' do
        submit
        expect(assigns.fetch :draft).to eql @draft
      end
      it 'renders the show template' do
        submit
        expect(response).to render_template 'show'
      end
    end
  end

  describe 'POST #create' do
    let :submit do
      post :create, form_draft: {name: 'test'}, commit: @commit
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect_any_instance_of(FormDraft).not_to receive :create
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      context 'commit is Save changes and continue editing' do
        before :each do
          @commit = 'Save changes and continue editing'
        end
        it 'creates a form with the changes given' do
          expect { submit }.to change { Form.count }.by 1
          expect(assigns[:draft].form.name).to eql 'test'
        end
        it 'redirects to the edit path for the draft' do
          submit
          expect(response).to redirect_to edit_form_draft_path(assigns[:draft])
        end
      end
      context 'commit is Preview changes' do
        before :each do
          @commit = 'Preview changes'
        end
        it 'updates the draft with the changes given' do
          expect { submit }.to change { Form.count }.by 1
          expect(assigns[:draft].form.name).to eql 'test'
        end
        it 'renders the show page' do
          submit
          expect(response).to render_template 'show'
        end
      end
    end
  end


  describe 'POST #update' do
    before :each do
      @draft = create :form_draft
      @changes = Hash['name', 'a new name']
    end
    let :submit do
      post :update, id: @draft,
                    form_draft: @changes,
                    commit: @commit
    end
    context 'not staff' do
      before :each do
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
      before :each do
        when_current_user_is :staff
      end
      context 'commit is Save changes and continue editing' do
        before :each do
          @commit = 'Save changes and continue editing'
        end
        it 'updates the draft with the changes given' do
          expect { submit }
            .to change { @draft.reload.name }
            .to 'a new name'
        end
        it 'reloads the draft' do
          expect_any_instance_of(FormDraft)
            .to receive(:reload)
          submit
        end
        it 'redirects to the edit path for the draft' do
          submit
          expect(response).to redirect_to edit_form_draft_path(@draft)
        end
      end
      context 'commit is Preview changes' do
        before :each do
          @commit = 'Preview changes'
        end
        it 'updates the draft with the changes given' do
          expect { submit }
            .to change { @draft.reload.name }
            .to 'a new name'
        end
        it 'renders the show page' do
          submit
          expect(response).to render_template 'show'
        end
      end
    end

    describe 'POST #update_form' do
      before :each do
        @draft = create :form_draft
      end
      let :submit do
        post :update_form, id: @draft.id
      end
      context 'not staff' do
        before :each do
          when_current_user_is :not_staff
        end
        it 'does not allow access' do
          expect_any_instance_of(FormDraft)
            .not_to receive :update_form!
          submit
          expect(response).to have_http_status :unauthorized
        end
      end
      context 'staff' do
        before :each do
          when_current_user_is :staff
        end
        it 'assigns the correct draft to the draft instance variable' do
          submit
          expect(assigns.fetch :draft).to eql @draft
        end
        it 'calls update_form! on the draft' do
          expect_any_instance_of(FormDraft)
            .to receive :update_form!
          submit
        end
        it 'includes a flash message' do
          submit
          expect(flash[:message]).not_to be_empty
        end
        it 'redirects to the forms index' do
          submit
          expect(response).to redirect_to forms_url
        end
      end
    end
  end
end
