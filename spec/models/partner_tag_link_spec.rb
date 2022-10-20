require 'rails_helper'

RSpec.describe PartnerTagLink, type: :model do
  subject { FactoryBot.create(:partner_tag_link) }

  describe "Associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :tag }
  end
end
