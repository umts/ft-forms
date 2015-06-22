FactoryGirl.define do
  factory :user do
    first_name 'FirstName'
    last_name 'LastName'
    staff false
    sequence(:spire) { |n| n.to_s.rjust 8, '0' }

    trait :staff do
      staff true
    end

    trait :not_staff do
      staff false
    end
  end
end
