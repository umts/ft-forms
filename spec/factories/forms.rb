# frozen_string_literal: true

FactoryGirl.define do
  factory :form do
    sequence(:name) { |n| "Form #{n}" }
    email 'form_email@test.host'

    trait :with_fields do
      after :create do |form|
        create :field, form: form
      end
    end
  end
end
