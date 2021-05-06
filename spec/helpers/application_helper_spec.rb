# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'input_class' do
    it 'returns datepicker for date' do
      expect(input_class('date')).to eql 'datepicker'
    end

    it 'returns datetimepicker for date/time' do
      expect(input_class('date/time')).to eql 'datetimepicker'
    end

    it 'returns nil for text' do
      expect(input_class('text')).to be nil
    end

    it 'returns timepicker for time' do
      expect(input_class('time')).to eql 'timepicker'
    end
  end

  describe 'parse_form_data' do
    before do
      # form data sent from view to controller
      @data = { 'prompt_1' => 'prompt value', 'field_1' => 'field value',
                'prompt_2' => 'prompt value 2', 'field_2' => 'field value 2',
                'heading_3' => 'heading value',
                'prompt_4' => 'prompt value 4', 'field_4' => 'field value 4' }
    end

    let :call do
      helper.parse_form_data(@data)
    end

    it 'returns an array of prompt and field pairs' do
      expect(call[0]).to eql ['prompt value', 'field value']
      expect(call[1]).to eql ['prompt value 2', 'field value 2']
      expect(call[3]).to eql ['prompt value 4', 'field value 4']
    end

    it 'assigns :heading as the value of a key containing heading' do
      expect(call[2][1]).to be :heading
    end
  end
end
