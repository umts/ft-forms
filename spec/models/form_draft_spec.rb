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
end
