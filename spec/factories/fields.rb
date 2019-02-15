# frozen_string_literal: true

FactoryBot.define do
  factory :field do
    data_type { Field::DATA_TYPES.sample }
    sequence :number
    prompt { 'Field prompt' }
    required  { true }
  end
end
