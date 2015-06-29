require 'rails_helper'

describe Form do
  describe 'create_draft' do
    before :each do
      @form = create :form
      @user = create :user
    end
    let :call do
      @form.create_draft @user
    end
    it 'creates a form draft' do
      expect { call }
        .to change { FormDraft.count }
        .by 1
    end
    it 'returns the draft' do
      expect(call).to be_a FormDraft
    end
    it 'sets the user of the form draft to the user argument' do
      expect(call.user).to eql @user
    end
    it 'sets the form of the draft to the current form' do
      expect(call.form).to eql @form
    end
    it 'adds the fields of the form to the draft' do
      # Meh, couldn't think of a better way of doing this
      expect(call.fields.size).to eql @form.fields.size
    end
  end
end
