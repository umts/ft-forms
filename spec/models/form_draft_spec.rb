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
end
