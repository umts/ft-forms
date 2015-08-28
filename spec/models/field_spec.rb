require 'rails_helper'

describe Field do
  context 'data_type identification methods' do
    before :each do
      @form = create :form
      @date        = create :field, form: @form, data_type: 'date'
      @explanation = create :field, form: @form, data_type: 'explanation'
      @heading     = create :field, form: @form, data_type: 'heading'
    end

    describe 'date?' do
      it 'returns true if data type is date' do
        expect(@date.date?).to eql true
      end
      it 'returns false if data type is not date' do
        expect(@explanation.date?).to eql false
      end
    end

    describe 'explanation?' do
      it 'returns true if data type is explanation' do
        expect(@explanation.explanation?).to eql true
      end
      it 'returns false if data type is not explanation' do
        expect(@heading.explanation?).to eql false
      end
    end

    describe 'heading?' do
      it 'returns true if data type is heading' do
        expect(@heading.heading?).to eql true
      end
      it 'returns false if data type is not heading' do
        expect(@date.heading?).to eql false
      end
    end
  end

  describe 'takes_placeholder?' do
    before :each do
      @draft = create :form_draft
    end
    it 'returns true for date, date/time, long-text, text or time' do
      %w(date date/time long-text text time).each do |data_type|
        field = create :field, form_draft: @draft, data_type: data_type
        expect(field.takes_placeholder?).to eql true
      end
    end
    it 'returns false for explanation, heading, number, options, or yes/no' do
      %w(explanation heading number options yes/no).each do |data_type|
        field = create :field, form_draft: @draft, data_type: data_type
        expect(field.takes_placeholder?).to eql false
      end
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
