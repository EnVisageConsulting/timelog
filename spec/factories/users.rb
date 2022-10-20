FactoryBot.define do
  # sequences
  sequence :email do |x|
    start = User.maximum(:id) || 1
    index = start + x

    "email#{index}@example.com"
  end

  sequence :last do |x|
    start = User.maximum(:id) || 1
    index = start + x
    "User #{index}"
  end


  # factories
  factory :user, aliases: [:inactive_user] do
    first {"Example"}
    last
    email
  end

  factory :active_user, parent: :user do
    password              {"Password10"}
    password_confirmation {"Password10"}
    activated_at          {1.second.ago}
  end

  factory :admin_user, parent: :active_user do
    first { "Admin" }
    last { "User" }
    role { :admin }
  end

  factory :partner_user, parent: :active_user do
    first { "Partner" }
    role { :partner }
    partner_projects { [create(:project)] }
  end

  factory :deactivated_user, parent: :active_user do
    deactivated_at {1.second.ago}
  end

  factory :invalid_user, parent: :user do
    first nil
    last nil
    email nil
  end
end
