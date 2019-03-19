# frozen_string_literal: true

FactoryBot.define do
  factory :form do
    sequence(:name) { |n| "Form #{n}" }
    email { 'form_email@test.host' }

    trait :with_fields do
      after :create do |form|
        Field::DATA_TYPES.each do |data_type|
          create :field, form: form, data_type: data_type
        end
      end
    end
  end
end
