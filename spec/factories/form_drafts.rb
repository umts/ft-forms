# frozen_string_literal: true

FactoryGirl.define do
  factory :form_draft do
    user
    name 'Draft name'
    trait :with_all_fields do
      after :create do |draft|
        Field::DATA_TYPES.each do |data_type|
          create :field, form_draft: draft, data_type: data_type
        end
      end
    end
  end
end
