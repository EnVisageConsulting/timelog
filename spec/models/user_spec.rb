require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do
    it { is_expected.to have_many :logs }
    it { is_expected.to have_many :password_recoveries }
  end

  describe "Validations" do
    subject { FactoryGirl.create :user }
    it { is_expected.to validate_presence_of :first }
    it { is_expected.to validate_presence_of :last }
    it { is_expected.to validate_presence_of :role }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_length_of(:email).is_at_most(256) }
    it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(64) }

    it { is_expected.to allow_value("example@mail.com").for(:email) }
    it { is_expected.to_not allow_value("email@mail").for(:email) }
    it { is_expected.to_not allow_value("mail.com").for(:email) }

    it { is_expected.to allow_value("Pass10Word").for(:password) }
    it { is_expected.to_not allow_value("password").for(:password) }
    it { is_expected.to_not allow_value("10000000").for(:password) }
  end

  describe "Class Methods" do
    let(:user) { FactoryGirl.create :user }

    describe "#with_email" do
      let!(:another_user) { FactoryGirl.create :user }
      let(:email)         { user.email }

      it "strips whitespace from search string" do
        query_email  = "    #{email}    "

        expect(User.with_email(query_email)).to_not eql another_user
        expect(User.with_email(query_email)).to     eql user
      end

      it "downcases search string" do
        expect(User.with_email(email.upcase)).to_not eql another_user
        expect(User.with_email(email.upcase)).to     eql user
      end
    end
  end

  describe "Setters & Getters" do
    let(:user) { FactoryGirl.create :user }

    describe "#email=" do
      it "trims whitespace" do
        email = "email@mail.com"
        user.email = "    #{email}    "

        expect(user.email).to eql email
      end

      it "downcases string" do
        upcased = "EMAIL@MAIL.COM"
        user.email = upcased

        expect(user.email).to eql upcased.downcase
      end
    end
  end

  describe "Instance Methods" do
    let(:user) { FactoryGirl.create :user }

    describe "#current_log" do
      it "returns the user's inactive log" do
        now = Time.now.in_time_zone(TIMEZONE)

        1.upto(3) do |num|
          start_at = (now - num.days).in_time_zone(TIMEZONE).midday
          end_at   = start_at + 4.hours

          FactoryGirl.create :active_log, user: user, start_at: start_at, end_at: end_at
        end

        current_log = FactoryGirl.create :log, user: user, start_at: now - 1.minute
        expect(user.current_log).to eql current_log

        # ensure that a new record (or active one) interferes with query
        FactoryGirl.create :active_log, user: user, start_at: now, end_at: now
        expect(user.reload.current_log).to eql current_log
      end
    end

    describe "#name" do
      subject { user.name }

      it { is_expected.to match /#{user.first} #{user.last}/ }
    end

    describe "#reverse_name" do
      subject { user.reverse_name }

      it { is_expected.to match /#{user.last}, #{user.first}/ }
    end

    describe "#deactivate!" do
      context "deactivating" do
        it "sets :deactivated_at if not set" do
          expect(user.deactivated_at).to be_nil

          expect {
            user.deactivate!
            user.reload
          }.to change(user, :deactivated_at).to be_within(1.minute).of(Time.now)
        end

        it "doesn't override :deactivated_at if set" do
          user.deactivated_at = 1.day.ago
          user.save
          user.reload

          expect(user.deactivated_at).to be_present

          expect {
            user.deactivate!
            user.reload
          }.to_not change(user, :deactivated_at)
        end
      end

      context "undeactivating" do
        it "sets :deactivated_at to nil" do
          user.deactivated_at = 1.day.ago
          user.save
          user.reload

          expect(user.deactivated_at).to be_present

          expect {
            user.deactivate! false
            user.reload
          }.to change(user, :deactivated_at).to be_nil
        end
      end
    end
  end
end
