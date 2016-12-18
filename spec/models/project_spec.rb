require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "Associations" do
    it { is_expected.to have_many :project_logs }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of :name }
  end

  describe "Scopes" do
  end

  describe "Setter & Getters" do
    let(:project) { FactoryGirl.create :project }

    describe "#deactivated" do
      it "returns truthy value if :deactivated_at is blank" do
        project.deactivated_at = nil

        expect(project.deactivated).to be_falsey
      end

      it "return falsey value if :deactivated_at value is set" do
        project.deactivated_at = 30.minutes.ago

        expect(project.deactivated).to be_truthy
      end
    end

    describe "#deactivated=" do
      context "setting with truthy value" do
        it "sets :deactivated_at to current time" do
          expect(project.deactivated_at).to be_nil

          expect {
            project.deactivated = true
          }.to change(project, :deactivated_at).to be_within(5.seconds).of Time.now
        end

        it "doesn't change :deactivated_at if already set" do
          project.deactivated_at = 30.minutes.ago

          expect {
            project.deactivated = true
          }.to_not change(project, :deactivated_at)
        end
      end

      context "setting with falsey value" do
        it "sets :deactivated_at to nil" do
          project.deactivated_at = 30.minutes.ago

          expect {
            project.deactivated = false
          }.to change(project, :deactivated_at).to be_nil
        end
      end
    end
  end
end
