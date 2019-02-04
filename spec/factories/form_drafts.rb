# frozen_string_literal: true

FactoryGirl.define do
  factory :form_draft do
    user
    name 'Draft name'
  end
end
