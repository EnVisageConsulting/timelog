FactoryBot.define do
  factory :project_log do
    log
    project
    description "example description text..."
  end

  factory :invalid_project_log, parent: :project_log do
    log nil
    project nil
    description nil
  end
end
