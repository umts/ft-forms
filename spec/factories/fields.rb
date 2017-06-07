# frozen_string_literal: true

FactoryGirl.define do
  factory :field do
    data_type 'text'
    sequence  :number
    prompt    'Field prompt'
    required  true
  end
end
