require 'rails_helper'

describe FormDraft do
  describe 'new_field' do
    before :each do
      @draft = create :form_draft
      # Create three existing fields - the number of the new one should be 4
      create :field, form_draft: @draft
      create :field, form_draft: @draft
      create :field, form_draft: @draft
    end
    let :call do
      @draft.new_field
    end
    it 'initializes a new field for the draft with the correct number' do
      expect(call.form_draft).to eql @draft
      expect(call.number).to eql 4
      expect(call.new_record?).to eql true
    end
  end

  describe 'remove_field' do
    before :each do
      @draft = create :form_draft
      @first_field  = create :field, form_draft: @draft
      @second_field = create :field, form_draft: @draft
      @third_field  = create :field, form_draft: @draft
    end
    let :call do
      @draft.remove_field @second_field.number
    end
    it 'removes the specified field' do
      call
      expect(@draft.reload.fields).not_to include @second_field
    end
    it 'does not change the number of any fields above the specified field' do
      expect { call }
        .not_to change { @first_field.reload.number }
    end
    it 'moves fields below the specified field up by one' do
      expect { call }
        .to change { @third_field.reload.number }
        .by(-1)
    end
  end

  describe 'update_form' do
    before :each do
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
      expect(FormDraft.where id: @draft.id).to be_empty
    end
  end
end
