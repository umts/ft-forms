# frozen_string_literal: true

FactoryBot.define do
  factory :field do
    data_type { 'text' }
    sequence :number
    prompt { 'Field prompt' }
    required { true }
    options { ['red'] if data_type == 'options' }
  end
end
