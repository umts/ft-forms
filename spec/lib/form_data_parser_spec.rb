# frozen_string_literal: true

require 'rails_helper'
require 'form_data_parser'

RSpec.describe FormDataParser do
  describe '#process!' do
    subject(:call) { described_class.new(data).process! }

    let(:data) do
      { 'prompt_1' => 'prompt value', 'field_1' => 'field value',
        'prompt_2' => 'prompt value 2', 'field_2' => 'field value 2',
        'heading_3' => 'heading value',
        'prompt_4' => 'prompt value 4', 'field_4' => 'field value 4' }
    end

    it 'returns an array of prompt and field pairs' do
      expect([call[0], call[1], call[3]])
        .to eq([['prompt value', 'field value'],
                ['prompt value 2', 'field value 2'],
                ['prompt value 4', 'field value 4']])
    end

    it 'assigns :heading as the value of a key containing heading' do
      expect(call[2][1]).to be :heading
    end
  end
end
