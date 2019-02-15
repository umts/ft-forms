# frozen_string_literal: true

FactoryBot.define do
  factory :form_draft do
    form
    user
    name { 'Draft name' }
  end
end
