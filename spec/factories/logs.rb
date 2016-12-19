FactoryGirl.define do
  factory :log, aliases: [:inactive_log] do
    user
    start_at Time.now

    trait :with_project_log do
      project_logs { [ FactoryGirl.build(:project_log) ] }
    end
  end

  factory :active_log, parent: :log do
    end_at Time.now
    project_logs { [ FactoryGirl.build(:project_log) ] }
  end

  factory :invalid_log, parent: :log do
    user nil
    start_at nil
    end_at nil
  end
end