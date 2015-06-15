FactoryGirl.define do
  factory :form do
    sequence(:name) { |n| "Form #{n}" }
  end
end
