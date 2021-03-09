# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FieldsController do
  describe 'GET #edit' do
    let :submit do
      get :edit, params: { id: @field.id }
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        @field = create :field, form: (create :form)
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      context 'field belongs to a form' do
        before :each do
          @field = create :field, form: (create :form)
        end
        it 'redirects back' do
          expect { submit }.to redirect_back
        end
      end
      context 'field belongs to a form draft' do
        before :each do
          @field = create :field, form_draft: (create :form_draft)
        end
        it 'assigns the correct field to the field instance variable' do
          submit
          expect(assigns.fetch :field).to eql @field
        end
        it 'renders the edit template' do
          submit
          expect(response).to render_template 'edit'
        end
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @field = create :field, form_draft: (create :form_draft)
      @options = %w[some options]
    end
    let :submit do
      post :update, params: { id: @field.id, options: @options.join("\r\n") }
    end
    context 'not staff' do
      before :each do
        when_current_user_is :not_staff
      end
      it 'does not allow access' do
        expect_any_instance_of(Field)
          .not_to receive :update
        submit
        expect(response).to have_http_status :unauthorized
      end
    end
    context 'staff' do
      before :each do
        when_current_user_is :staff
      end
      context 'field belongs to a form' do
        before :each do
          @field = create :field, form: (create :form)
        end
        it 'redirects back' do
          expect { submit }.to redirect_back
        end
      end
      context 'fields belongs to a form draft' do
        # no setup needed
        it 'assigns the correct field to the field instance variable' do
          submit
          expect(assigns.fetch :field).to eql @field
        end
        it 'updates the field based on newline-separated options' do
          submit
          expect(@field.reload.options).to eql @options
        end
        it 'redirects to the edit path for the form draft of the field' do
          submit
          expect(response).to redirect_to edit_form_draft_path @field.form_draft
        end
      end
    end
  end
end
