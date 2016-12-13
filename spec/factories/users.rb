FactoryGirl.define do
  # sequences
  sequence :email do |n|
    "email#{n}@example.com"
  end


  # factories
  factory :user, aliases: [:inactive_user] do
    first "Example"
    last  "User"
    email
  end

  factory :active_user, parent: :user do
    password              "password10"
    password_confirmation "password10"
    activated_at          1.second.ago
  end

  factory :deactivated_user, parent: :active_user do
    deactivated_at 1.second.ago
  end

  factory :invalid_user, parent: :user do
    first nil
    last nil
    email nil
  end
end