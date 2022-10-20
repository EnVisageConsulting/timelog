FactoryBot.define do
  factory :partner_tag_link do
    user { create(:partner_user) }
    tag
  end
end
