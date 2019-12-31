FactoryBot.define do
  factory :project do
    sequence(:name) { |x| "Project #{x}" }
  end

  factory :deactivated_project, parent: :project do
    deactivated_at {1.second.ago}
  end

  factory :invalid_project, parent: :project do
    name nil
  end
end
