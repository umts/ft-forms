FactoryGirl.define do
  factory :user do
    first_name 'FirstName'
    last_name 'LastName'
    email 'flastnam@test.host'
    staff false
    sequence :spire

    trait :staff do
      staff true
    end

    trait :not_staff do
      staff false
    end
  end
end
