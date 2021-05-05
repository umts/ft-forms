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
end
