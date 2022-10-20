FactoryBot.define do
  factory :partner_project_link do
    user { create(:partner_user) }
    project
  end
end
