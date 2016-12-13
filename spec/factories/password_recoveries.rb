FactoryGirl.define do
  factory :password_recovery do
    user
  end

  factory :invalid_password_recovery, parent: :password_recovery do
    user nil
  end
end
