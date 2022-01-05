# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Form do
  let(:form) { create :form }
  let(:user) { create :user }

  describe 'create_draft' do
    subject(:call) { form.find_or_create_draft(user) }

    let(:field_props) do
      lambda do |form_or_draft|
        form_or_draft.fields.map do |field|
          field.attributes.symbolize_keys
               .except(:id, :created_at, :updated_at, :form_id, :form_draft_id)
        end
      end
    end

    before { create_list(:field, 3, form: form) }

    context 'with a pre-existing draft belonging to user' do
      let!(:draft) { create :form_draft, form: form, user: user }

      it { is_expected.to eq draft }
    end

    context 'without a pre-existing draft' do
      it 'creates a new FormDraft' do
        expect { call }.to change(FormDraft, :count).by(1)
      end

      it { is_expected.to be_a FormDraft }

      it 'sets the user of the form draft to the user argument' do
        expect(call.user).to eq user
      end

      it 'sets the form of the draft to the current form' do
        expect(call.form).to eq form
      end

      it 'adds the fields of the form to the draft' do
        expect(field_props[call]).to eq field_props[form]
      end
    end
  end

  describe 'draft_belonging_to' do
    let!(:draft) { create :form_draft, form: form, user: user }

    before do
      other_user = create :user
      create :form_draft, form: form, user: other_user
    end

    it 'returns the draft of the form belonging to the user' do
      expect(form.draft_belonging_to(user)).to eq draft
    end
  end

  describe 'draft_belonging_to?' do
    subject(:call) { form.draft_belonging_to? user }

    it 'returns false if draft does not exist for the user in question' do
      expect(call).to be false
    end

    it 'returns true if draft exists for the user in question' do
      create :form_draft, user: user, form: form
      expect(call).to be true
    end
  end
end
