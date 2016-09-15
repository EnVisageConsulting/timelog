FactoryGirl.define do
  factory :log do
    user
    start_at Time.now
  end
end