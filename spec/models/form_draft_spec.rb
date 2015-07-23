require 'rails_helper'

describe FormDraft do
  describe 'move_field' do
    before :each do
      @draft = create :form_draft
      @field_above   = create :field, form_draft: @draft, number: 1
      @field_to_move = create :field, form_draft: @draft, number: 2
      @field_below   = create :field, form_draft: @draft, number: 3
      @number = @field_to_move.number
    end
    let :call do
      @draft.move_field @number, @direction
    end
    context 'direction is up' do
      before :each do
        @direction = :up
      end
      it 'moves the field in question up by 1' do
        expect { call }
          .to change { @field_to_move.reload.number }
          .by(-1)
      end
      it 'moves the field above down by 1' do
        expect { call }
          .to change { @field_above.reload.number }
          .by 1
      end
      it 'does not change the field below' do
        expect { call }
          .not_to change { @field_below.reload.number }
      end
    end
    context 'direction is down' do
      before :each do
        @direction = :down
      end
      it 'moves the field in question down by 1' do
        expect { call }
          .to change { @field_to_move.reload.number }
          .by 1
      end
      it 'moves the field below up by 1' do
        expect { call }
          .to change { @field_below.reload.number }
          .by(-1)
      end
      it 'does not change the field above' do
        expect { call }
          .not_to change { @field_above.reload.number }
      end
    end
  end

  describe 'new_field' do
    before :each do
      @draft = create :form_draft
      # Create three existing fields - the number of the new one should be 4
      create :field, form_draft: @draft, number: 1
      create :field, form_draft: @draft, number: 2
      create :field, form_draft: @draft, number: 3
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

  describe 'update_fields' do
    before :each do
      @draft = create :form_draft
      @field = create :field, form_draft: @draft
      @new_prompt = 'A new prompt'
      # keys don't matter, ignored in method
      @field_data = {
        0 => {
          number: @field.number,
          prompt: 'A new prompt'
        },
        1 => {
          number: @field.number + 1,
          prompt: 'A prompt',
          data_type: 'text',
          required: true
        }
      }
    end
    let :call do
      @draft.update_fields @field_data
    end
    it 'updates existing fields' do
      expect { call }
        .to change { @field.reload.prompt }
        .to @new_prompt
    end
    it 'creates new fields if none existing with that number' do
      expect { call }
        .to change { @draft.fields.count }
        .by 1
    end
  end

  describe 'update_form!' do
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
