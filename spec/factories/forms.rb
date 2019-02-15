# frozen_string_literal: true

FactoryBot.define do
  factory :form do
    sequence(:name) { |n| "Form #{n}" }
    email { 'form_email@test.host' }
  end
end
