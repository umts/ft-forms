FactoryGirl.define do
  factory :form do
    sequence(:name) { |n| "Form #{n}" }
    email 'form_email@test.host'
  end
end
