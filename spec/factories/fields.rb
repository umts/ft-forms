# frozen_string_literal: true

FactoryGirl.define do
  factory :field do
    data_type Field::DATA_TYPES.sample
    sequence  :number
    prompt    'Field prompt'
    required  true
    options { ['red'] if data_type == 'options' }
  end
end
