require 'rails_helper'

describe Field do
  context 'data_type identification methods' do
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

  # I prefer not to write `to be takes_placeholder`.
  # rubocop:disable UmtsCustomCops/PredicateMethodMatcher
  describe 'takes_placeholder?' do
    before :each do
      @draft = create :form_draft
    end
    it 'returns true for date, date/time, long-text, text or time' do
      %w(date date/time long-text text time).each do |data_type|
        field = create :field, form_draft: @draft, data_type: data_type
        expect(field.takes_placeholder?).to be true
      end
    end
    it 'returns false for explanation, heading, number, options, or yes/no' do
      %w(explanation heading number options yes/no).each do |data_type|
        field = create :field, form_draft: @draft, data_type: data_type
        expect(field.takes_placeholder?).to be false
      end
    end
  end

  describe 'unique_name' do
    before :each do
      @form = create :form
      @field = create :field, form: @form
    end
    it 'returns field followed by number' do
      result = ['field', @field.number].join '_'
      expect(@field.unique_name).to eql result
    end
  end

  describe 'unique_prompt_name' do
    before :each do
      @form = create :form
      @field = create :field, form: @form
    end
    it 'returns prompt followed by number' do
      result = ['prompt', @field.number].join '_'
      expect(@field.unique_prompt_name).to eql result
    end
  end

  describe 'unique_heading_name' do
    before :each do
      @form = create :form
      @field = create :field, form: @form
    end
    it 'returns heading followed by number' do
      result = ['heading', @field.number].join '_'
      expect(@field.unique_heading_name).to eql result
    end
  end

  context 'validation methods' do
    describe 'belongs_to_form_or_form_draft?' do
      before :each do
        @form = create :form
        @draft = create :form_draft
      end
      it 'fails if a field does not belong to a form or form draft' do
        expect { create :field }
          .to raise_error ActiveRecord::RecordInvalid
      end
      it 'fails if a field belongs to both a form and a form draft' do
        expect { create :field, form: @form, form_draft: @draft }
          .to raise_error ActiveRecord::RecordInvalid
      end
      it 'passes if a field belongs to a form but not a form draft' do
        expect { create :field, form: @form }
          .not_to raise_error
      end
      it 'passes if a field belongs to a form draft but not a form' do
        expect { create :field, form_draft: @draft }
          .not_to raise_error
      end
    end
  end
end
