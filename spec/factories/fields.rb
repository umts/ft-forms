# frozen_string_literal: true

FactoryBot.define do
  factory :field do
    data_type { 'text' }
    sequence :number
    prompt { 'field prompt' }
    required  { true }
  end
end
