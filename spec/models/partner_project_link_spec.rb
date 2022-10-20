require 'rails_helper'

RSpec.describe PartnerProjectLink, type: :model do
  subject { FactoryBot.create(:partner_project_link) }

  describe "Associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :project }
  end
end
