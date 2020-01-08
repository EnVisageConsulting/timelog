require 'rails_helper'

RSpec.describe ProjectLog, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to :log }
    it { is_expected.to belong_to :project }
  end

  describe "Validations" do
    subject { FactoryBot.build :project_log }
    it { is_expected.to validate_presence_of :project_id }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :total_allocation }
    it { is_expected.to validate_presence_of :billable_allocation }
    it { is_expected.to validate_presence_of :percent }
    # it { is_expected.to validate_numericality_of(:percent).is_less_than_or_equal_to(100).with_message("cannot be greater than 100%") }
    # it { is_expected.to validate_numericality_of(:percent).is_greater_than_or_equal_to(0).with_message("cannot be less than 0%") }
  end

  describe "Setters & Getters" do
    let(:project_log) { FactoryBot.build :project_log }

    describe "#percent=" do
      it "converts string values to percent (as decimals) and sets :total_allocation" do
        project_log.percent = "90%"
        expect(project_log.total_allocation).to eql 0.9

        project_log.percent = "50" # % is optional
        expect(project_log.total_allocation).to eql 0.5
      end

      it "converts numerical values to percent (as decimal) and sets :total_allocation" do
        project_log.percent = 50
        expect(project_log.total_allocation).to eql 0.5
      end
    end

    describe "#percent" do
      it "returns :total_allocation as percent in string" do
        project_log.total_allocation = 0.2
        expect(project_log.percent).to eql "20"
      end

      it "returns nil if :total_allocation is nil" do
        project_log.total_allocation = nil
        expect(project_log.percent).to be_nil
      end
    end
  end
end
