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
