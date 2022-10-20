FactoryBot.define do
  factory :tag do
    sequence(:name) { |x| "Tag #{x}" }
  end

  factory :deactivated_tag, parent: :tag do
    deactivated_at {1.second.ago}
  end
end
