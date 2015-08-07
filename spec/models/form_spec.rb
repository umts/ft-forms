require 'rails_helper'

describe Form do
  describe 'create_draft' do
    before :each do
      @form = create :form
      create :field, form: @form
      create :field, form: @form
      create :field, form: @form
      @user = create :user
    end
    let :call do
      @form.create_draft @user
    end
    context 'pre-existing draft belonging to user' do
      before :each do
        create :form_draft, form: @form, user: @user
      end
      it 'returns false' do
        expect(call).to eql false
      end
    end
    context 'no pre-existing draft' do
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

  describe 'draft_belonging_to' do
    before :each do
      @user = create :user
      other_user = create :user
      @form = create :form
      @draft = create :form_draft, form: @form, user: @user
      # other draft
      create :form_draft, form: @form, user: other_user
    end
    it 'returns the draft of the form belonging to the user' do
      expect(@form.draft_belonging_to @user).to eql @draft
    end
  end

  describe 'draft_belonging_to?' do
    before :each do
      @form = create :form
      @user = create :user
    end
    let :call do
      @form.draft_belonging_to? @user
    end
    it 'returns false if a draft exists for the user in question' do
      expect(call).to eql false
    end
    it 'returns true if a draft does not exist for the user in question' do
      create :form_draft, user: @user, form: @form
      expect(call).to eql true
    end
  end
end
