# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormDraft do
  describe 'update_form!' do
    before do
      @form = create :form, name: 'Form name'
      @draft = create :form_draft, form: @form, name: 'Draft name'
      # One field for each
      @form_field = create :field, form: @form
      @draft_field = create :field, form_draft: @draft
    end

    let :call do
      @draft.update_form!
    end

    it 'changes the form to have the same attributes as the draft' do
      expect { call }
        .to change { @form.reload.name }
        .from('Form name')
        .to 'Draft name'
    end

    it 'deletes all the fields of the form' do
      call
      # It amounts to the same thing, right?
      expect(@form.reload.fields).not_to include @form_field
    end

    it 'moves the draft fields over to the form' do
      call
      expect(@form.reload.fields).to include @draft_field
    end

    it 'destroys itself' do
      call
      expect(FormDraft.where(id: @draft.id)).to be_empty
    end
  end
end
