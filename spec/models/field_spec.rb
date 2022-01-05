# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Field do
  let(:field) { create :field, form: create(:form) }

  context 'with data_type identification methods' do
    let(:form) { create :form }
    let(:date) { create :field, form: form, data_type: 'date' }
    let(:explanation) { create :field, form: form, data_type: 'explanation' }
    let(:heading) { create :field, form: form, data_type: 'heading' }

    describe 'date fields' do
      subject { date }

      it { is_expected.to be_date }
      it { is_expected.not_to be_explanation }
      it { is_expected.not_to be_heading }
    end

    describe 'explanation fields' do
      subject { explanation }

      it { is_expected.to be_explanation }
      it { is_expected.not_to be_heading }
      it { is_expected.not_to be_date }
    end

    describe 'heading fields' do
      subject { heading }

      it { is_expected.to be_heading }
      it { is_expected.not_to be_date }
      it { is_expected.not_to be_explanation }
    end
  end

  describe 'takes_placeholder?' do
    let(:draft) { create :form_draft }

    %w[date date/time long-text text time].each do |data_type|
      it "returns true for #{data_type}" do
        field = create :field, form_draft: draft, data_type: data_type
        expect(field.takes_placeholder?).to be true
      end
    end

    %w[explanation heading number options yes/no].each do |data_type|
      it "returns false for #{data_type}" do
        field = create :field, form_draft: draft, data_type: data_type
        expect(field.takes_placeholder?).to be false
      end
    end
  end

  describe 'unique_name' do
    subject(:call) { field.unique_name }

    it { is_expected.to eq "field_#{field.number}" }
  end

  describe 'unique_prompt_name' do
    subject(:call) { field.unique_prompt_name }

    it { is_expected.to eq "prompt_#{field.number}" }
  end

  describe 'unique_heading_name' do
    subject(:call) { field.unique_heading_name }

    it { is_expected.to eq "heading_#{field.number}" }
  end

  describe 'belongs_to_form_or_form_draft?' do
    let(:form) { create :form }
    let(:draft) { create :form_draft }

    it 'fails if a field does not belong to a form or form draft' do
      expect(build(:field)).not_to be_valid
    end

    it 'fails if a field belongs to both a form and a form draft' do
      field = build :field, form: form, form_draft: draft
      expect(field).not_to be_valid
    end

    it 'passes if a field belongs to a form but not a form draft' do
      expect(build(:field, form: form)).to be_valid
    end

    it 'passes if a field belongs to a form draft but not a form' do
      expect(build(:field, form_draft: draft)).to be_valid
    end
  end
end
