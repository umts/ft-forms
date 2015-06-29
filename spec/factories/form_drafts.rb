FactoryGirl.define do
  factory :form_draft do
    association :form
    association :user
    name 'Draft name'
  end
end
