require 'rails_helper'

RSpec.describe PasswordRecovery, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to :user }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:user).with_message "with that email doesn't exist" }
  end

  describe "Callbacks" do
    describe "#set_expiration" do
      let(:password_recovery) { FactoryGirl.build :password_recovery }

      it "assigns an :expires_at on validation" do
        expect(password_recovery.expires_at).to be_nil

        expect {
          password_recovery.valid?
        }.to change(password_recovery, :expires_at).to be_within(5.minutes).of 1.day.from_now
      end

      it "doesn't change :expires_at if already set" do
        password_recovery.expires_at = Time.now

        expect {
          password_recovery.valid?
        }.to_not change(password_recovery, :expires_at)
      end
    end
  end

  describe "Setters & Getters" do
    let(:password_recovery) { FactoryGirl.build :password_recovery }

    describe "#email" do
      let(:user) { password_recovery.user }

      it "returns associated user's email if present" do
        expect(password_recovery.email).to eql user.email

        password_recovery.user = nil
        expect(password_recovery.email).to be_nil
      end
    end

    describe "#email=" do
      it "finds user associated with supplied email string" do
        new_user = FactoryGirl.create :user
        expect(password_recovery.user).to_not eql new_user

        password_recovery.email = new_user.email
        expect(password_recovery.user).to eql new_user
      end
    end
  end

  describe "Instance Methods" do
    let(:password_recovery) { FactoryGirl.create :password_recovery }

    describe "#to_param" do
      subject { password_recovery.to_param }

      it { is_expected.to eql password_recovery.token }
    end

    describe "#expired?" do
      it "returns truthy if :expires_at is in the past" do
        password_recovery.expires_at = 1.minute.ago
        expect(password_recovery.expired?).to be_truthy

        password_recovery.expires_at = 1.minute.from_now
        expect(password_recovery.expired?).to be_falsey
      end

      it "returns falsey if :expires_at is blank" do
        password_recovery.expires_at = nil
        expect(password_recovery.expired?).to be_falsey
      end
    end

    describe "#expire!" do
      let(:password_recovery) { FactoryGirl.create :password_recovery }

      it "sets :expires_at and persists" do
        expect {
          password_recovery.expire!
          password_recovery.reload
        }.to change(password_recovery, :expires_at).to be_within(1.minute).of(Time.now)
      end
    end
  end
end
